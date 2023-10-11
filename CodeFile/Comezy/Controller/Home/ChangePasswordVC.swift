//
//  ChangePasswordVC.swift
//  Comezy
//
//  Created by amandeepsingh on 02/08/22.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    let objChangePasswordViewModel = ChangePasswordViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        if self.currentPassword.text?.isEmpty == true {
            self.showAlert(message: "Please enter your current password.")
        } else if self.newPassword.text?.isEmpty == true {
            self.showAlert(message: "Please enter new password.")
        } else if self.confirmPassword.text?.isEmpty == true{
            self.showAlert(message: "Please enter confirm password.")
        } else if self.newPassword.text != self.confirmPassword.text {
            self.showAlert(message: "New password and confirm password must be same.")
        } else if isValidPassword(self.newPassword.text ?? "") == false{
            self.showAlert(message: "Password must contain 8 characters,1 uppercase, 1 lowercase, 1 digit, 1 symbol")
        }  else {
            self.objChangePasswordViewModel.changePassword(oldPassword: currentPassword.text!, newPassword: newPassword.text!, confirmPassword: confirmPassword.text!){ success, eror in
                if success {
                    self.navigationController?.popViewController(animated: true)

                    self.showToast(message: SuccessMessage.kPasswordChangeSuccess, font: .boldSystemFont(ofSize: 14.0))

                } else {
                    self.showAlert(message: FailureMessage.kPasswordChangeFailure)
                }
            }
        }
        
    }
    
    
    
    @IBAction func changeCurrentAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentPassword.isSecureTextEntry = !sender.isSelected
        
    }
    
    
    @IBAction func newPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        newPassword.isSecureTextEntry = !sender.isSelected
        
    }
    
    @IBAction func confirmPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        confirmPassword.isSecureTextEntry = !sender.isSelected
        
    }
    
    
}
