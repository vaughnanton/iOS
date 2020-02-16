//
//  AppDelegate.swift
//  07whiteHouseJsonParser
//
//  Created by Vaughn on 6/14/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch - code for inserting a second ViewController in our tab bar
        // storyboard automatically creates a window where all our view controllers are shown, the window needs to know which is the initial which
        // gets set to the rootViewController property
        // in a single view app the rootViewController is the ViewController, but we embedded ours in navigation and tab bar controller so now it is
        // UITabBarController
        if let tabBarController = window?.rootViewController as? UITabBarController {
            // create a new ViewController by hand, so we reference our main story board file, nil means use my current app bundle
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // pass in the storyboard ID we set earlier, NavController
            let vc = storyboard.instantiateViewController(withIdentifier: "NavController")
            // create a UITabBarItem object, giving it Top Rated icon and the tag 1
            vc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
            // add the new view controller to our tab bar controller's viewControllers array 
            tabBarController.viewControllers?.append(vc)
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

