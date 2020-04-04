import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindowController : MainWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainWC = MainWindowController() //create a window controller
        mainWC.showWindow(self) //put the window of the WC on screen
        mainWindowController = mainWC
    }

    
    

}

