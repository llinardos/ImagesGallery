import UIKit
import ImageGallery
import MockedImagesSource
import PexelsImagesSource

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  var app: ImageGallery.App!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let source = MockImagesSource()
//    let source = PexelsImagesSource(apiKey: "")
    let app = App(imagesSource: source)
    app.run(on: window)
    
    window.makeKeyAndVisible()
    
    return true
  }
}
