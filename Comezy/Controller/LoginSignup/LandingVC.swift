//
//  LandingVC.swift
//  Comezy
//
//  Created by MAC on 09/07/21.
//

import UIKit
var isFromDynamicLink = false
var globalInvitedPerson: InvitePersonModel?
class LandingVC: UIViewController {
    static var userId: Int?
    var Userdata: UserDataModel?
    var invitedPerson: InviteWorkerModel?
    let button = UIButton(type: .custom)
    
    @IBOutlet weak var btnSignInWithEmail: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    let objSignupViewModel = SignupViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        txtPassword.rightView = button
        txtPassword.rightViewMode = .always
        button.alpha = 1.0
        button.tintColor = .white
    
        initialLoad()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        txtEmail.addBottomLine(vC:self)
        txtPassword.addBottomLine(vC: self)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        txtPassword.enablePasswordToggle()
        if isFromDynamicLink {
            let vc = ScreenManager.getController(storyboard: .main, controller: SignupVC()) as! SignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print("rootViewController ->", self.navigationController?.rootViewController?.className)
//        print("ViewControllers on Landing ->",self.navigationController?.viewControllers)
//        print("windows ->",UIApplication.shared.windows)

    }
    
    @objc func togglePasswordView(_ sender: Any) {
        txtPassword.isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }
    
 
}

//MARK:- Custom functions -
//MARK: Custom functions
extension LandingVC{
    
    var keyWindow:UIWindow?{
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    private func setWindowLevel() {
        if let window  =  self.keyWindow{
            window.windowLevel = UIWindow.Level.normal
        }
    }
    func initialLoad(){
        
        setWindowLevel()
        //Bottom layer on textField
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        self.navigationBarTitle(headerTitle: "", backTitle: "")
        self.btnSignInWithEmail.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnSignInWithEmail.clipsToBounds = true
    }
}

//MARK:- Button actions -
//MARK: Button actions
extension LandingVC{
    
    
    @IBAction func signUp_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: SignupVC()) as! SignupVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signInWithEmail_action(_ sender: Any) {
        self.objSignupViewModel.getEmailString(email: txtEmail.text ?? "", password: txtPassword.text ?? "", controller: self) { (success, message) in
            if success {
            
                AppDelegate.shared.setSlideMenuController(.notifications)
            }else {
                self.showAlert(message: message)
            }
        }
        
    }
    
    @IBAction func forgotPwd_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: ForgotPasswordVC()) as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @IBAction func signupWithFb_action(_ sender: Any) {
        SocialLogin.shared.facebookSignIn(viewController: self) { (UserDetail) in
            self.objSignupViewModel.getsignupDetails(signupType: "social", controller: self, first_name: UserDetail.firstName ?? "", last_name: UserDetail.lastName ?? "", user_type: UserType.kOwner, email: UserDetail.userEmail ?? "", password: "", cpassword: "", phone: "", facebook_token: UserDetail.socialLoginId ?? "", apple_token: "", google_token: "", occupation: 1, company: "", signature: "") { (success, message, type) in
                if success {
                    if type == "login"{
                        AppDelegate.shared.setSlideMenuController(.notifications)
                    } else {
                        let vc = ScreenManager.getController(storyboard: .main, controller: SignupVC()) as! SignupVC
                        vc.userDetail = UserDetail
                        vc.isSocialLogin = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                } else {
                    self.showAlert(message: message)
                }
            }
        } failure: { (error) in
            self.showAlert(message: error?.localizedDescription ?? "")
        }

        
       
    }
    @IBAction func signuoWithGoogle_action(_ sender: Any) {
        SocialLogin.shared.googleSignIn(viewController: self) { [self] (UserDetail) in
            print(UserDetail)
            print("printing firstname", UserDetail.firstName)
            self.objSignupViewModel.getsignupDetails(signupType: "social", controller: self, first_name: UserDetail.firstName ?? "", last_name: UserDetail.lastName ?? "", user_type: UserType.kOwner, email: UserDetail.userEmail ?? "", password: "", cpassword: "", phone: "", facebook_token: "", apple_token: "", google_token: UserDetail.socialLoginId ?? "", occupation: 1, company: "", signature: "") { (success , message, type) in
                if success {
                    if type == "login"{
                    AppDelegate.shared.setSlideMenuController(.notifications)
                }else {
                    let vc = ScreenManager.getController(storyboard: .main, controller: SignupVC()) as! SignupVC
                    vc.userDetail = UserDetail
                    vc.isSocialLogin = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                }else{
                    
                    self.showAlert(message: message)
                }
            }
        } failure: { (error) in
            self.showAlert(message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func signupWithApple_action(_ sender: Any) {
        if #available(iOS 13, *) {
            FRAppleSignHandler.shared.appleSignIn { [self] (UserDetail) in
                print(UserDetail)
                self.objSignupViewModel.getsignupDetails(signupType: "social", controller: self, first_name: UserDetail.firstName ?? "", last_name: UserDetail.lastName ?? "", user_type: UserType.kOwner, email: UserDetail.userEmail ?? "", password: "", cpassword: "", phone: "", facebook_token: "", apple_token: UserDetail.socialLoginId ??  "", google_token: "", occupation: 1, company: "", signature: "") { (success , message, type) in
                    if success {
                        if type == "login"{
                        AppDelegate.shared.setSlideMenuController(.notifications)
                    }else {
                        let vc = ScreenManager.getController(storyboard: .main, controller: SignupVC()) as! SignupVC
                        vc.userDetail = UserDetail
                        vc.isSocialLogin = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    }else{
                        
                        self.showAlert(message: message)
                    }
                }
            } failure: { (error) in
                self.showAlert(message: error?.localizedDescription ?? "")
            }

        } else {
            // Fallback on earlier versions
        }
        
        
        
//        SocialLogin.shared.googleSignIn(viewController: self) { [self] (UserDetail) in
//            print(UserDetail)
//            self.objSignupViewModel.getsignupDetails(signupType: "social", controller: self, first_name: UserDetail.firstName ?? "", last_name: UserDetail.lastName ?? "", user_type: "owner", email: UserDetail.userEmail ?? "", password: "", cpassword: "", phone: "", facebook_token: "", apple_token: UserDetail.socialLoginId ?? "", google_token:  "", occupation: 1, company: "", signature: "") { (success, message, type) in
//                if success {
//                    if type == "login"{
//                    AppDelegate.shared.setSlideMenuController(.myProjects)
//                }else {
//                    let vc = ScreenManager.getController(storyboard: .main, controller: SignupVC()) as! SignupVC
//                    vc.userDetail = UserDetail
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                }else{
//                    self.showAlert(message: message)
//                }
//            }
//        } failure: { (error) in
//            self.showAlert(message: error?.localizedDescription ?? "")
//        }
    }
}
