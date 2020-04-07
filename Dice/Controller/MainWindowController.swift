import Cocoa

class MainWindowController: NSWindowController {

    
    override var windowNibName: NSNib.Name? {
        return "MainWindowController"
    }
    
    var configurationWC : ConfigurationWindowController?
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func showDieConfiguration(sender: AnyObject?) {
        
        if let w = window, let dieView = w.firstResponder as? DieView {
            let wc = ConfigurationWindowController()
            wc.config = DieConfiguration(color: dieView.color, rolls: dieView.numberOfRolls)
            w.beginSheet(wc.window!) { (response) in
                if response == .OK {
                    let config = self.configurationWC!.config
                    dieView.color = config.color
                    dieView.numberOfRolls = config.rolls
                }
                self.configurationWC = nil
            }
            configurationWC = wc
        }
        
    }
    

    
}
