//
//  AppDelegate.swift
//  kaiseki
//
//  Created by Ed Chao on 4/1/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import UIKit
import Firebase




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navC: UINavigationController?
    var homeVC: HomeViewController?
    var authVC: AuthViewController?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // FIREBASE
        
        FIRApp.configure()
        
        
        
        if FIRAuth.auth()?.currentUser != nil {
            navC = UINavigationController()
            homeVC = HomeViewController()
            navC!.pushViewController(homeVC!, animated: false)
        } else {
            navC = UINavigationController()
            authVC = AuthViewController()
            navC!.pushViewController(authVC!, animated: false)
        }
        
//        FIRAuth.auth()?.signIn(withEmail: "aaa@aaa.com", password: "aaaaaa", completion: { (user:FIRUser?, error:Error?) in
//            if error == nil {
//                print(user?.email ?? "This is the user email")
//            }else{
//                print(error?.localizedDescription ?? "this is the error localized description")
//            }
//        })
        
        
        // NAVIGATION STACk
        
//        navC = UINavigationController()
//        homeVC = HomeViewController()
//        navC!.pushViewController(homeVC!, animated: false)
        

     
        
        // NAVIGATION BACK IMAGE
        
        var backButtonImage = UIImage(named: "btn-back")
        backButtonImage = backButtonImage?.stretchableImage(withLeftCapWidth: 26, topCapHeight: 26)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: UIControlState.selected, barMetrics: .default)

        
        // STATUS BAR
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.tintColor = UIColor.white
            statusBar.backgroundColor = UIColor.ink(alpha: 1.0)
        }
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        // WINDOW
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            window.rootViewController = navC
            window.makeKeyAndVisible()
            window.layer.cornerRadius = 4.0
            window.layer.masksToBounds = true
            window.layer.isOpaque = false
        }
        return true

   
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

