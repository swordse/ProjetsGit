//
//  FabulaSwiftUIApp.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 31/05/2022.
//

import SwiftUI
//import FirebaseCore
import Firebase
import GoogleMobileAds
import UserMessagingPlatform

class AppDelegate: NSObject, UIApplicationDelegate {

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
//    GADMobileAds.sharedInstance().start(completionHandler: nil)
    return true
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

