//
//  AppDelegate.swift
//  100DaysForEnglish
//
//  Created by Vu Tinh on 2/12/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shareInstance = {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor.colorFormHex(0x00CCFF)
        //Connect facebook
        connectFacebook(application, launchOptions: launchOptions)
        //Connect google
        configSignInByGoogle()
        configSetRootViewWhenLogin()
        return true
    }

    func configSetRootViewWhenLogin() {
        //let userInfo = UserInfoModel()
        //userInfo.loadFromUserDefault()
        
      //  if userInfo.idToken != "" {
            loginSeccess()
        //} else {
          //  loginVC()
        //}
    }
    
    func loginVC() {
        // get your storyboard
        let storyboard = UIStoryboard(name: "LoginAndRegister", bundle: nil)
        
        // instantiate your desired ViewController
        let rootController = storyboard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! LoginNavigationController
        
        // Because self.window is an optional you should check it's value first and assign your rootViewController
        if let window = self.window {
            window.rootViewController = rootController
        }
    }
    
    func loginSeccess() {
        
        // get your storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate your desired ViewController
        let rootController = storyboard.instantiateViewControllerWithIdentifier("ContainerHomeVC") as! ContainerHomeVC
        
        // Because self.window is an optional you should check it's value first and assign your rootViewController
        if let window = self.window {
            window.rootViewController = rootController
        }
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = 0
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

