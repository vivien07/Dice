import Cocoa


class DieView: NSView {
    
    //MARK: - Properties
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 20, height: 20)
    }
    
    var numberOfDots: Int? = 1 {
        didSet {
            needsDisplay = true //when the value is being changed, the view has to be redrawn
        }
    }
    
    var pressed: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    var highlighted: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    var color: NSColor = NSColor.red {
        didSet {
            needsDisplay = true
        }
    }
    
    var numberOfRolls: Int = 10
    var mouseDownEvent: NSEvent?
    var rollsRemaining = 0 //helps to determine when to stop the timer
    
    //MARK: - Initializers
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commomInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commomInit()
    }
    
    
    func commomInit() {
        self.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
    }
    
    //MARK: - First Responder
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    override func drawFocusRingMask() {
        NSBezierPath.fill(metricsForSize(size: bounds.size).dieFrame)
    }
    
    override var focusRingMaskBounds: NSRect {
        return bounds
    }
    
    //MARK: - Drawing
    
    override func draw(_ dirtyRect: NSRect) {
        
        let bgColor = NSColor.lightGray
        bgColor.set()
        NSBezierPath.fill(bounds)
        if highlighted {
            let gradient = NSGradient(starting: color, ending: bgColor)
            gradient?.draw(in: bounds, relativeCenterPosition: NSZeroPoint)
        } else {
            drawDieWithSize(size: bounds.size)
        }
        
    }
    
    
    func metricsForSize(size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect) {
        
        let edgeLength = min(size.width, size.height)
        let padding = edgeLength/10.0
        let drawingBounds = CGRect(x: 0, y: 0, width: edgeLength, height: edgeLength)
        var dieFrame = drawingBounds.insetBy(dx: padding, dy: padding)  //Returns a rectangle with an origin that is offset from that of the source rectangle.
        if pressed {
            dieFrame = dieFrame.offsetBy(dx: 0, dy: -edgeLength/40)
        }
        return (edgeLength, dieFrame)
        
    }
    
    
    func drawDieWithSize(size: CGSize) {
        
        if let numberOfDots = numberOfDots {
            
            let (edgeLength, dieFrame) = metricsForSize(size: size)
            let cornerRadius: CGFloat = edgeLength/5.0
            let dotRadius = edgeLength/12.0
            //draw the die profile
            let dotFrame = dieFrame.insetBy(dx: dotRadius*2.5, dy: dotRadius*2.5)
            NSGraphicsContext.saveGraphicsState()
            
            let shadow = NSShadow()
            shadow.shadowOffset = NSSize(width: 0, height: -1)
            shadow.shadowBlurRadius = (pressed ? edgeLength/100 : edgeLength/20)
            shadow.set()
            
            color.set()
            NSBezierPath(roundedRect: dieFrame, xRadius: cornerRadius, yRadius: cornerRadius).fill()
            
            NSColor.black.set()
            NSBezierPath.defaultLineWidth = 3
            NSBezierPath.defaultLineCapStyle = NSBezierPath.LineCapStyle.round
            NSBezierPath(roundedRect: dieFrame, xRadius: cornerRadius, yRadius: cornerRadius).stroke()
            
            NSGraphicsContext.restoreGraphicsState()   //no shadow from here
            NSColor.white.set()
            
            func drawDot(u: CGFloat, v: CGFloat) {
                let dotOrigin = CGPoint(x: dotFrame.minX + dotFrame.width * u, y: dotFrame.minY + dotFrame.height * v)
                let dotRect = CGRect(origin: dotOrigin, size: CGSize.zero).insetBy(dx: -dotRadius, dy: -dotRadius)  //a square
                NSBezierPath(ovalIn: dotRect).fill()    //a circle inside the square
            }
            
            if (numberOfDots >= 1 && numberOfDots <= 9) {
                switch numberOfDots {
                case 1:
                    drawDot(u: 0.5, v: 0.5)
                case 2:
                    drawDot(u: 0, v: 1)
                    drawDot(u: 1, v: 0)
                case 3:
                    drawDot(u: 0, v: 1)
                    drawDot(u: 1, v: 0)
                    drawDot(u: 0.5, v: 0.5)
                case 4:
                    drawDot(u: 0, v: 0)
                    drawDot(u: 0, v: 1)
                    drawDot(u: 1, v: 0)
                    drawDot(u: 1, v: 1)
                case 5:
                    drawDot(u: 0, v: 0)
                    drawDot(u: 0, v: 1)
                    drawDot(u: 1, v: 0)
                    drawDot(u: 1, v: 1)
                    drawDot(u: 0.5, v: 0.5)
                case 6:
                    drawDot(u: 0, v: 0)
                    drawDot(u: 0, v: 1)
                    drawDot(u: 1, v: 0)
                    drawDot(u: 1, v: 1)
                    drawDot(u: 0, v: 0.5)
                    drawDot(u: 1, v: 0.5)
                default:
                    let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                    paraStyle.alignment = .center
                    let attrs = [NSAttributedString.Key.foregroundColor: NSColor.white,
                                 NSAttributedString.Key.font: NSFont.systemFont(ofSize: edgeLength * 0.5),
                                 NSAttributedString.Key.paragraphStyle: paraStyle]
                    let string = "\(numberOfDots)" as NSString
                    string.drawCenteredInRect(rect: dieFrame, attributes: attrs)
                }
            }
            
        }//end of if block
        
    }
    
    
    
    //MARK: - Mouse Events
    
    override func mouseDown(with event: NSEvent) {
        mouseDownEvent = event
        //checks if the user clicked in the die's view
        let dieFrame = metricsForSize(size: bounds.size).dieFrame
        let point = convert(event.locationInWindow, from: nil)
        pressed = dieFrame.contains(point)
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        let downPoint = mouseDownEvent!.locationInWindow
        let dragPoint = event.locationInWindow
        let distanceDragged = hypot(downPoint.x - dragPoint.x, downPoint.y - dragPoint.y)
        if distanceDragged < 3 { return } //ensures there are no accidental drags
        pressed = false
        if let numberOfDots = numberOfDots {
            let image = NSImage(size: bounds.size, flipped: false) { (imageBounds) -> Bool in
                self.drawDieWithSize(size: imageBounds.size)
                return true
            }
            let draggingFrameOrigin = convert(downPoint, from: nil)
            let draggingFrame = NSRect(origin: draggingFrameOrigin, size: bounds.size)
                .offsetBy(dx: -bounds.size.width/2, dy: -bounds.size.height/2)
            let nsstring = String(numberOfDots) as NSString
            let item = NSDraggingItem(pasteboardWriter: nsstring)
            item.draggingFrame = draggingFrame
            item.imageComponentsProvider = {
                let component = NSDraggingImageComponent(key: .icon)
                component.contents = image
                component.frame = NSRect(origin: NSPoint(), size: self.bounds.size)
                return [component]
            }
            beginDraggingSession(with: [item], event: mouseDownEvent!, source: self)
        }
        
    }
    
    
    override func mouseUp(with event: NSEvent) {
        if (pressed == true && event.clickCount == 2) {
            roll()
        }
        pressed = false
    }
    
    
    func randomize() {
        numberOfDots = Int.random(in: 1...6)
        rollsRemaining -= 1
    }
    
    
    //MARK: - Keyboard Events
    
    
    override func keyDown(with event: NSEvent) {
        interpretKeyEvents([event])
    }
    
    override func insertText(_ insertString: Any) {
        let text = insertString as! String
        if let number = Int(text) {
            numberOfDots = number
        }
    }
    
    override func insertTab(_ sender: Any?) {
        window?.selectNextKeyView(sender)
    }
    
    override func insertBacktab(_ sender: Any?) {
        window?.selectPreviousKeyView(sender)
    }
    
    
    @IBAction func savePDF(sender: AnyObject) {
        
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["pdf"]
        savePanel.beginSheetModal(for: window!) { (result) in
            if result == .OK {
                let data = self.dataWithPDF(inside: self.bounds)
                do {
                    try data.write(to: savePanel.url!, options: .atomic)
                } catch {
                    let alert = NSAlert(error: error)
                    alert.runModal()
                }
            }
        }
        
    }
    
    
    //MARK: - Pasteboard
    
    func writeToPasteboard(pasteboard: NSPasteboard) {
        
        if numberOfDots != nil {
            pasteboard.clearContents()
            let nsstring = String(numberOfDots!) as NSString
            pasteboard.writeObjects([nsstring])
        }
        
    }
    
    
    func readFromPasteboard(pasteboard: NSPasteboard) -> Bool {
        
        let objects = pasteboard.readObjects(forClasses: [NSString.self], options: [:] ) as! [String]
        if let str = objects.first {
            numberOfDots = Int(str)
            return true
        }
        return false
        
    }
    
    @IBAction func cut(sender: AnyObject?) {
        writeToPasteboard(pasteboard: NSPasteboard.general)
        numberOfDots = nil
    }
    
    @IBAction func copy(sender: AnyObject?) {
        writeToPasteboard(pasteboard: NSPasteboard.general)
    }
    
    @IBAction func paste(sender: AnyObject?) {
        readFromPasteboard(pasteboard: NSPasteboard.general)
    }

    
    //MARK: - Timer
    
    func roll() {
        rollsRemaining = numberOfRolls
        Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(rollTick), userInfo: nil, repeats: true)
        window?.makeFirstResponder(nil) //removes the blue selection indicator
    }
    
    
    @objc func rollTick(sender: Timer) {
        randomize()
        if rollsRemaining == 0 {
            sender.invalidate()
            window?.makeFirstResponder(self)
        }
        
    }

    
    
}


extension DieView: NSDraggingSource {
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .all
    }
    
   //called when the dragging session has completed.
    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        if operation == .delete {
            numberOfDots = nil
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        //disallows the drag if the source is the same as the destination
        let source = sender.draggingSource as? DieView
        if source === self {
            return []
        }
        highlighted = true
        return sender.draggingSourceOperationMask
    }
    
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        highlighted = false
    }
    
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return readFromPasteboard(pasteboard: sender.draggingPasteboard)
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        highlighted = false
    }
    
    
}


