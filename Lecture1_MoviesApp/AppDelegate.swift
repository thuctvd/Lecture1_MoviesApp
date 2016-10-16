//
//  AppDelegate.swift
//  Lecture1_MoviesApp
//
//  Created by Truong Vo Duy Thuc on 10/10/16.
//  Copyright © 2016 thuctvd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
      
    // Set up the first View Controller
    let nowPlayingNav = storyBoard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
    nowPlayingNav.tabBarItem.title = "Now Playing"
    nowPlayingNav.tabBarItem.image = UIImage(named: "movies")
    let nowPlayingVC = nowPlayingNav.topViewController as! MoviesViewController
    nowPlayingVC.endPoint = "now_playing"
    
    // Set up the second View Controller
    let topRatedNav = storyBoard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
    topRatedNav.tabBarItem.title = "Top Rated"
    topRatedNav.tabBarItem.image = UIImage(named: "star")
    let topRatedVC = topRatedNav.topViewController as! MoviesViewController
    topRatedVC.endPoint = "top_rated"
    
    // Set up the Tab Bar Controller to have two tabs
    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [nowPlayingNav, topRatedNav]
    tabBarController.tabBar.barTintColor = UIColor.lightGray
    
    // Make the Tab Bar Controller the root view controller
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()
    
    UINavigationBar.appearance().tintColor = UIColor.black
    UINavigationBar.appearance().backgroundColor = UIColor.black
    
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

