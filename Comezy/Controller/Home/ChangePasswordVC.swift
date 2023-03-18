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
