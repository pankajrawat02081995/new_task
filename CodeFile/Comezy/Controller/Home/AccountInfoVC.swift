//
//  AccountInfoVC.swift
//  Comezy
//
//  Created by amandeepsingh on 30/07/22.
//

import UIKit
import FirebaseFirestore

class AccountInfoVC: UIViewController {
    var db = Firestore.firestore()
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileDetail: UIStackView!
    @IBOutlet weak var changePassword: UIStackView!
    @IBOutlet weak var deleteAccount: UIStackView!
    @IBOutlet weak var deleteAccountLine: UIView!
    var objAccountInfoVM = DeleteAccountViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let changePasswordTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.changePassword(_:)))
        changePassword.isUserInteractionEnabled = true
        changePassword.addGestureRecognizer(changePasswordTap)
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileDetail(_:)))
        
        profileDetail.isUserInteractionEnabled = true
        profileDetail.addGestureRecognizer(tap)
        
        let deleteAccountTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.deleteAccount(_:)))
        deleteAccount.isUserInteractionEnabled = true
        deleteAccount.addGestureRecognizer(deleteAccountTap)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let url = URL(string: (kUserData?.profile_picture)!){
            userProfile.kf.setImage(with: url)
            userProfile.contentMode = .scaleAspectFill
        }
        userName.text = "\(String(describing: kUserData!.first_name!.capitalized))"+" "+"\(String(describing:kUserData!.last_name!.capitalized))"
        self.db.collection("app_status").document("wTBmkujMo3Fp4ipQ6ebu")
            .addSnapshotListener { (snapshot,error) in
                if let error = error {
                    self.deleteAccount.isHidden = true
                    self.deleteAccountLine.isHidden=true
                }
                else{
                    var a = snapshot?.data()!["isLive"]
                    if(a as! Int != 0 ){
                        self.deleteAccount.isHidden = true
                        self.deleteAccountLine.isHidden=true

                    }else{
                        self.deleteAccount.isHidden = false
                        self.deleteAccountLine.isHidden=false

                    }
                }
    }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
   
    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    @objc func changePassword(_ sender: UITapGestureRecognizer){
        print("PASSWORD")
        let vc = ScreenManager.getController(storyboard: .projectStatus, controller: ChangePasswordVC()) as! ChangePasswordVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func profileDetail(_ sender: UITapGestureRecognizer){
        print("PROFILEDETAIL")
        let vc = ScreenManager.getController(storyboard: .projectStatus, controller: ProfileDetailsVC()) as! ProfileDetailsVC
        navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func deleteAccount(_ sender: UITapGestureRecognizer) {
        showAppAlert(title: "Delete Account", message: "Do you want to delete account") {
            // print("Account Deleted")
            self.objAccountInfoVM.deleteAccount() { success, response, msg in
                if success {
                    DispatchQueue.main.async {
                        AppDelegate.shared.signOut()
                        self.showToast(message: "Account Deleted Successfully")
                    }
                }
            }
        }
        
    }
}
