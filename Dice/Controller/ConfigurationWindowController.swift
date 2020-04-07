import Cocoa

struct DieConfiguration {
    
    let color: NSColor
    let rolls: Int
    
    init(color: NSColor, rolls: Int) {
        self.color = color
        self.rolls = max(rolls, 1)  //ensures the property is greater than zero
    }
    
}



class ConfigurationWindowController: NSWindowController {

    
    override var windowNibName: NSNib.Name? {
           return "ConfigurationWindowController"
       }
    
    @objc private dynamic var color: NSColor = NSColor.red
    @objc private dynamic var rolls: Int = 10
    
    var config: DieConfiguration {
        set {
            color = newValue.color
            rolls = newValue.rolls
        }
        get {
            return DieConfiguration(color: color, rolls: rolls)
        }
    }
    
    
    @IBAction func okButtonClicked(button: NSButton) {
        window?.endEditing(for: nil)    //To make sure the user's changes are applied
        dismiss(response: NSApplication.ModalResponse.OK)
    }
    
    
    @IBAction func cancelButtonClicked(button: NSButton) {
        dismiss(response: NSApplication.ModalResponse.cancel)
    }
    
    func dismiss(response: NSApplication.ModalResponse) {
        window?.sheetParent?.endSheet(window!, returnCode: response)    //Ends the modal session with the specified return code.
    }
    
}
