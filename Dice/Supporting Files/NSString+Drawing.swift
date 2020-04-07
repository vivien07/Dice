import Cocoa


extension NSString {
    
    
    func drawCenteredInRect(rect: NSRect, attributes: [NSAttributedString.Key: Any]) {
        
        let stringSize = size(withAttributes: attributes)
        let point = NSPoint(x: rect.origin.x + (rect.width - stringSize.width)/2.0,
                            y: rect.origin.y + (rect.height - stringSize.height)/2.0)
        draw(at: point, withAttributes: attributes)
        
    }
       
    
}
