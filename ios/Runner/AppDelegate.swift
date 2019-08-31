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
    GMSPlacesClient.provideAPIKey("AIzaSyDPmfMCWQcPRNZOcsGXszKGJMs11FbUxtc")
    GMSServices.provideAPIKey("AIzaSyDPmfMCWQcPRNZOcsGXszKGJMs11FbUxtc")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
