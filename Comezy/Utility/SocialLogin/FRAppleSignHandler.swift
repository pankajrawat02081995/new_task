//
//  AppleHandler.swift
//  Bhakti_Vikasa
//
//  Created by Harsh Rajput on 19/09/20.
//  Copyright © 2020 Harsh Rajput. All rights reserved.
//
//NOTE IOS 12 LOWER: ADD other linking Flaf <~> weak_framework CryptoKit
import Foundation
import CryptoKit
import AuthenticationServices
import JWTDecode


// Unhashed nonce.
@available(iOS 13, *)
class FRAppleSignHandler:NSObject{
    fileprivate var currentNonce: String?

    static let shared = FRAppleSignHandler()
       private override init() {
           
       }
    
    var userType = ""
    let window = UIWindow()
    var controller = UIViewController()
    typealias successBlock = (UserDataModel) -> Void
    typealias failureBlock = (Error?) -> Void
    
    var onSuccess : successBlock!
    var onFailure: failureBlock!

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    
    func nativeAppleBTN(loginProviderView:UIView){
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        
        authorizationButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        authorizationButton.frame = loginProviderView.frame
        authorizationButton.layer.cornerRadius = authorizationButton.frame.size.height/2
        authorizationButton.clipsToBounds = true
        loginProviderView.addSubview(authorizationButton)
        
        
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        authorizationButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
//        authorizationButton.frame = loginProviderView.frame
//        authorizationButton.clipsToBounds = true
//        loginProviderView.addSubview(authorizationButton)
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    func appleSignIn(success: @escaping successBlock, failure: @escaping failureBlock) {
        onSuccess = success
        onFailure = failure
        startSignInWithAppleFlow()
    }

    @objc func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email,]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
       // authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
      authorizationController.performRequests()
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}
@available(iOS 13, *)
extension FRAppleSignHandler: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      
      
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
        
        if let identityTokenData = appleIDCredential.identityToken,
        let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
        print("Identity Token \(identityTokenString)")
        do {
           let jwt = try decode(jwt: identityTokenString)
           let decodedBody = jwt.body as Dictionary<String, Any>
            let email = decodedBody["email"] as? String ?? "n/a"
           print("Decoded body ->", decodedBody)
           print("Decoded email: "+(decodedBody["email"] as? String ?? "n/a")   )
            print("Printing fullname ->", appleIDCredential.fullName)
            let userDetails = UserDataModel.init(userEmail: appleIDCredential.email ?? email, firstName: appleIDCredential.fullName?.givenName ?? "",lastName: appleIDCredential.fullName?.familyName ?? "", profileImage: "" ,socialLoginId: idTokenString ?? "", socialType: "apple")
            self.onSuccess(userDetails)
        } catch {
           print("decoding failed")
        }
        }

     
        
//      // Initialize a Firebase credential.
//      let credential = OAuthProvider.credential(withProviderID: "apple.com",
//                                                idToken: idTokenString,
//                                                rawNonce: nonce)
//      // Sign in with Firebase.
//      Auth.auth().signIn(with: credential) { (authResult, error) in
//        if (error != nil) {
//          // Error. If error.code == .MissingOrInvalidNonce, make sure
//          // you're sending the SHA256-hashed nonce as a hex string with
//          // your request to Apple.
//            print(error?.localizedDescription)
//          return
//        }else{
//            print("USer login WIth Apple")
//            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                if Auth.auth().currentUser != nil{
//
//                }
//            }
//        }
//      }
    }else {
        self.onFailure(nil)
    }
  }
    
    func completeSignIn(completionHandler:@escaping (_ sucess:Bool,_ eror:String?) -> Void) {
        //self.onFailure(eror)
    }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
