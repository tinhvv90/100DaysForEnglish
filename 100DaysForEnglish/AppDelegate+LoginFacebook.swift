//
//  AppDelegate+LoginFacebook.swift
//  CustomerTaxiApp
//
//  Created by Vu Tinh on 1/17/17.
//  Copyright © 2017 Trương Thắng. All rights reserved.
//

import Foundation
import UIKit

//Connect facebook
extension AppDelegate {
    func connectFacebook(application: UIApplication,launchOptions: [NSObject : AnyObject]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}
