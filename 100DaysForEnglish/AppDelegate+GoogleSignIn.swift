//
//  AppDelegate+GoogleSignIn.swift
//  CustomerTaxiApp
//
//  Created by Vu Tinh on 1/17/17.
//  Copyright © 2017 Trương Thắng. All rights reserved.
//

import Foundation
import UIKit


extension AppDelegate: GIDSignInDelegate {
    
    //Connect google
    func configSignInByGoogle() {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
    }
    
    // MARK: GIDSignInDelegate
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            var imageGoogle : NSURL! = NSURL(string: "")
            if user.profile.hasImage
            {
                imageGoogle = user.profile.imageURLWithDimension(100)
                print("google avatar: \(imageGoogle)")
            }
            let type = AccountType.google
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            
            let userInfo = UserInfoModel(name: fullName, email: email, idToken: idToken, givenName: givenName, familyName: familyName, type: type, avatarUrl: String(imageGoogle), userId: userId)
            
            userInfo.saveToUserDefault()
            configSetRootViewWhenLogin()
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
    }
}
