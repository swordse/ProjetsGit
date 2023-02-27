//
//  AnecdoteDuJourApp.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 13/01/2023.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import Glassfy

@main
struct AnecdoteDuJourApp: App {
    
    @StateObject var networkChecker = NetworkChecker()
    
    init() {
        Glassfy.initialize(apiKey: "538e4b26bd8d404a8f0c5b7ee520b949")
        UITableView.appearance().backgroundColor = .clear
    }
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//            MainView()
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(networkChecker)
//                .onAppear{
//                    PurchaseManager.shared.configure()
//                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
}
