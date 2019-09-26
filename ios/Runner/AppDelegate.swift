import UIKit
import Flutter
import GooglePlaces
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSPlacesClient.provideAPIKey("AIzaSyB3Ux1Qpg9Ul1aA36g-fnQelUUT06qWJFI")
    GMSServices.provideAPIKey("AIzaSyB3Ux1Qpg9Ul1aA36g-fnQelUUT06qWJFI")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
