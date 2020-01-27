import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
    } else {
      let settings: UIUserNotificationSettings =
      UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
//    if #available(iOS 10.0, *) {
//      UNUserNotificationCenter.current().delegate = self as?UNUserNotificationCenterDelegate
//    }
    GMSServices.provideAPIKey("AIzaSyBPyhyGOHdrur7NmsyLStjhpitr_6IknCc")
    GeneratedPluginRegistrant.register(with: self)
   // GMSPlacesClient.provideAPIKey("AIzaSyB3Ux1Qpg9Ul1aA36g-fnQelUUT06qWJFI")
   // GMSServices.provideAPIKey("AIzaSyB3Ux1Qpg9Ul1aA36g-fnQelUUT06qWJFI")
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
