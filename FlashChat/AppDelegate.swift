//
//  AppDelegate.swift
//  FlashChat
//
//  Created by Daniela Lima on 2022-07-18.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        //if there's no error, should get "FIRFirestore:" printed in debug area when running the app
        print(db)
        
        IQKeyboardManager.shared.enable = true
        
        // to customise the keyboard and to hide the toolbar
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        // resign textField if touched outside of UITextField
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // For issues with IQKeyboardManagerSwift scrolling up the Navigation bar when it scrolls up the tableView,
        // found a solution here: https://developer.apple.com/forums/thread/684454
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

