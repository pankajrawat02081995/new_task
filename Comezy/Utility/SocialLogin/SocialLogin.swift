//
//  SocialLogin.swift
//  LoginSignUp
//
//  Created by archie on 19/02/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SocialLogin: NSObject {

    static let shared = SocialLogin()
    var currentVC = UIViewController()
    typealias successBlock = (UserDataModel) -> Void
    typealias failureBlock = (Error?) -> Void
    
    var onSuccess : successBlock!
    var onFailure: failureBlock!
    
    func configureGoogleSignIn() {
       // let signInConfig = GIDConfiguration.init(clientID: "YOUR_IOS_CLIENT_ID")
        //FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "664064985539-a9pghgl09fd0c7p85jbkg4e4lco7ecmq.apps.googleusercontent.com"//FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func googleSignIn(viewController: UIViewController, success: @escaping successBlock, failure: @escaping failureBlock) {
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
        currentVC = viewController
        onSuccess = success
        onFailure = failure
        GIDSignIn.sharedInstance().signIn()
    }
    
}

//MARK:- Google SignIn Delegates -
extension SocialLogin: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      if let error = error {
        onFailure(error)
      }else {
        
        print(user.profile.imageURL(withDimension: 20))
          let nameSplit = user.profile?.name?.split(separator: " ")
          let firstName = String(nameSplit?[0] ?? "")
        let userDetails = UserDataModel.init(userEmail: user.profile?.email ?? "", firstName: firstName,lastName: user.profile?.familyName ?? "", profileImage: "\(user.profile.imageURL(withDimension: 60) ?? URL(fileURLWithPath: ""))" ,socialLoginId: user.userID ?? "", socialType: "google")
        self.onSuccess(userDetails)
         
      }
     
    }
    

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        onFailure(error)
    }
}

//Facebook Integration
extension SocialLogin {
    func addFacebookButton(view: UIView) {
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    func facebookSignIn(viewController: UIViewController, success: @escaping successBlock, failure: @escaping failureBlock) {
        let loginManager = LoginManager()
      
           onSuccess = success
        onFailure = failure
           if let _ = AccessToken.current {
               // Access token available -- user already logged in
               loginManager.logOut()
               
           } else {
               // Access token not available -- user already logged out
               loginManager.logIn(permissions: ["email"], from: viewController) { [weak self] (result, error) in
                   
                   guard error == nil else {
                       // Error occurred
                    self?.onFailure(error)
                    return
                   }
                   
                   guard let result = result, !result.isCancelled else {
                    self?.onFailure(nil)
                       return
                   }
            
                   Profile.loadCurrentProfile { (profile, error) in
                    let userDetails = UserDataModel.init(userEmail: profile?.email ?? "", firstName: profile?.firstName ?? "",lastName: profile?.lastName, profileImage: "\(profile?.imageURL ?? URL(fileURLWithPath: ""))" ,socialLoginId: profile?.userID ?? "", socialType: "fb")
                    print(userDetails)
                    self?.onSuccess(userDetails)
                    
                   }
               }
           }
    }
}
