//
//  LoginTableViewController.swift
//  100DaysForEnglish
//
//  Created by Vu Tinh on 2/13/17.
//  Copyright © 2017 Vu Tinh. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func faceBookAction(sender: AnyObject) {
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.loginBehavior = FBSDKLoginBehavior.Browser
        facebookLoginManager.logInWithReadPermissions(["email"], fromViewController: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.fetchUserInfo()
                    //fbLoginManager.logOut()
                }
            }
        }
    }
    
    func fetchUserInfo(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    let type = AccountType.facebook
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    let email = result.valueForKey("email") as! String
                    let id = result.valueForKey("id") as! String
                    let name = result.valueForKey("name") as! String
                    let givenName = result.valueForKey("first_name") as! String
                    let familyName = result.valueForKey("last_name") as! String
                    let avatarUrl = "https://graph.facebook.com/\(id)/picture?type=large"
                    
                    let userInfo = UserInfoModel(name: name, email: email, idToken: accessToken, givenName: givenName, familyName: familyName, type: type, avatarUrl: avatarUrl, userId: id)
                    
                    userInfo.saveToUserDefault()
                    AppDelegate.shareInstance.configSetRootViewWhenLogin()
                }
            })
        }
    }
    
    @IBAction func googleAction(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
}
