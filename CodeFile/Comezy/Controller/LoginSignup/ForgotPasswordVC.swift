//
//  ForgotPasswordVC.swift
//  Comezy
//
//  Created by shiphul on 11/11/21.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    let objSignupViewModel = SignupViewModel()
    var myEmailList = UserBasicDetails()
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var sendLinkBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
       
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendLinkBtn_action(_ sender: Any) {
        self.objSignupViewModel.getPassLink(email: txtEmail.text?.lowercased() ?? "") { (success, message) in
            if success {
//                AppDelegate.shared.setSlideMenuController(.myProjects)
                self.showAlert(message: "A link has been sent to your email address") {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showAlert(message: message)
            }
            
        }
        
        
    }
    
}
extension ForgotPasswordVC{
    func initialLoad(){
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        self.sendLinkBtn.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.sendLinkBtn.clipsToBounds = true
    }
}
