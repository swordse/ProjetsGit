//
//  FabulaSwiftUIApp.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 31/05/2022.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import UserMessagingPlatform
import UserNotifications
import FirebaseMessaging

@available(iOS 14.0, *)
@main
struct FabulaSwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegateadsize

    init() {
        isAuthentificate()
//        FirebaseApp.configure()
//         to be able to make appear the backgroundcolor of Zstack
        UITableView.appearance().backgroundColor = .clear
        // to avoid selection tint color in list
        UITableViewCell.appearance().selectionStyle = .none

        UITableView.appearance().separatorStyle = .none

        UITextView.appearance().backgroundColor = .clear

        UITextField.appearance().backgroundColor = .clear
       
    }
    
    func isAuthentificate() {
        Task(priority: .background) {
            let currentUser: FabulaUser?
            try await  currentUser = AuthService().getCurrentUser()
            if currentUser != nil {
                UserDefaultsManager.manager.saveCurrentUser(user: currentUser!)
            }
        }
    }
    
    // register app delegate for Firebase setup
//      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    @StateObject private var userDefaultsManager = UserDefaultsManager()
//    @State private var isShowingWelcome = false
    
    var body: some Scene {
        WindowGroup {
//            if UserDefaultsManager.manager.isNewUser() {
//                WelcomeVie
//            }
            
//                MainTabView()

            MainView()
//                .environmentObject(userDefaultsManager)
//                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}

class AppDelegate: NSObject, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
      
      FirebaseApp.configure()
    
      // pour le consentement pour adMob
      let parameters = UMPRequestParameters()
      // Set tag for under age of consent. Here false means users are not under age.
      parameters.tagForUnderAgeOfConsent = false

      // Request an update to the consent information.
      UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
          with: parameters,
          completionHandler: { [self] error in
            if error != nil {
                print(error)
              // Handle the error.
            } else {
              // The consent information state was updated.
              // You are now ready to check if a form is
              // available.
                let formStatus = UMPConsentInformation.sharedInstance.formStatus
                        if formStatus == UMPFormStatus.available {
                          loadForm()
                        }
            }
          })
      
      Messaging.messaging().delegate = self

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

              application.registerForRemoteNotifications()
              
//    GADMobileAds.sharedInstance().start(completionHandler: nil)
    return true
  }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

         if let messageID = userInfo[gcmMessageIDKey] {
           print("Message ID: \(messageID)")
         }

         print(userInfo)

         completionHandler(UIBackgroundFetchResult.newData)
       }
    
    func loadForm() {
        UMPConsentForm.load(completionHandler: { form, loadError in
        if loadError != nil {
          // Handle the error.
        } else {
          // Present the form. You can also hold on to the reference to present
          // later.
          if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
              form?.present(from: UIApplication.shared.windows.first!.rootViewController! as UIViewController, completionHandler: { dimissError in
                                          if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                                              // App can start requesting ads.
                                              GADMobileAds.sharedInstance().start(completionHandler: nil)
                                          }

                })
          } else {
            // Keep the form available for changes to user consent.
          }
        }
      })
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}
