import Cocoa


class DieView: NSView {
    
    var numberOfDots: Int? = 1 {
        didSet {
            needsDisplay = true //when the value is being changed, the view has to be redrawn
        }
    }
    
    
    override var intrinsicContentSize: NSSize {
        return NSSize(width: 20, height: 20)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        let bgColor = NSColor.lightGray
        bgColor.set()
        NSBezierPath.fill(bounds)
        drawDieWithSize(size: bounds.size)
        
    }
    
    
    func metricsForSize(size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect) {
        
        let edgeLength = min(size.width, size.height)
        let padding = edgeLength/10.0
        let drawingBounds = CGRect(x: 0, y: 0, width: edgeLength, height: edgeLength)
        let dieFrame = drawingBounds.insetBy(dx: padding, dy: padding)
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
            shadow.shadowBlurRadius = edgeLength/20
            shadow.set()
            NSColor.red.set()
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
            if (numberOfDots >= 1 && numberOfDots <= 6) {
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
                    return
                }
            }
            
            
        }//end of if block
        
    }
   
    
}


