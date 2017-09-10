//
//  AppDelegate.swift
//  Flicks
//
//  Created by Soumya on 1/13/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowPlayingNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationStoryboardId") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesTableViewController
        nowPlayingViewController.endpoint = "now_playing"
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named: "video")
        // style navigation controller
        nowPlayingNavigationController.navigationBar.barTintColor = UIColor.flk_appThemeColor()
        nowPlayingNavigationController.navigationBar.tintColor = UIColor.darkGray
        nowPlayingNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]  // Title's text color

        
        let topRatedNavigationController = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationStoryboardId") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesTableViewController
        topRatedViewController.endpoint = "top_rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named: "star")
        // style navigation controller
        topRatedNavigationController.navigationBar.barTintColor = UIColor.flk_appThemeColor()
        topRatedNavigationController.navigationBar.tintColor = UIColor.darkGray
        nowPlayingNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]  // Title's text color


        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, topRatedNavigationController]
        
        // styling tab bar
        tabBarController.tabBar.barTintColor = UIColor.flk_appThemeColor()
        tabBarController.tabBar.tintColor = UIColor.black // color selected tab icon and text black
        
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

