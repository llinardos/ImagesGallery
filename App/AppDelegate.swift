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
    
//    let source = MockImagesSource()
    
    let apiKey = readPexelsAPIKeyFromInfoPlist() ?? ""
    let source = PexelsImagesSource(apiKey: apiKey)
    let app = App(imagesSource: source)
    self.app = app
    app.run(on: window)
    
    window.makeKeyAndVisible()
    
    return true
  }
}

public func readPexelsAPIKeyFromInfoPlist() -> String? {
  return Bundle.main.object(forInfoDictionaryKey: "PEXELS_API_KEY").flatMap({ $0 as? String })
}
