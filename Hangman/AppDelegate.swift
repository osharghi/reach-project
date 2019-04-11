//
//  AppDelegate.swift
//  Hangman
//
//  Created by Omid Sharghi on 4/8/19.
//  Copyright © 2019 Omid Sharghi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let historyArray : [History] = Array()
        let usedWordsSet = Set<String>()
        let currentDict: [String] = Array()
        
//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: pastWords, requiringSecureCoding: false)

        
//        UserDefaults.standard.register(defaults: [
//            "History": resultArray,
//            "WordsUsed": encodedData,
//            "lastDifficulty": 5,
//            "lastDictionary": currentDict
//            ])
        
        UserDefaults.standard.set(5, forKey: "lastDifficulty")
        UserDefaults.standard.set(historyArray, forKey: "History")
        UserDefaults.standard.set(currentDict, forKey: "lastDictionary")
//        UserDefaults.standard.set(usedWordsSet, forKey: "usedWordsSet")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(usedWordsSet), forKey:"usedWordsSet")


        
        

        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "MainView") as! ViewController
        nav1.viewControllers = [resultViewController]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
        
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

