//
//  ProfileDetailsVC.swift
//  Comezy
//
//  Created by amandeepsingh on 02/08/22.
//

import UIKit

class ProfileDetailsVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var lblAbn: UILabel!
    
    @IBOutlet weak var abnView: UIView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    
    var profileVM = ProfileDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.profileVM.getProfileDetails {
            let kData = self.profileVM.jsonData?.data
            self.email.text = kData?.email
            self.address.text = kData?.address
            self.lblAbn.text = kData?.aBN
            
            if let url = URL(string: kData?.profile_picture ?? "") {
                self.userImage.kf.setImage(with: url)
                self.userImage.contentMode = .scaleAspectFill
            }
            
            if(kUserData?.user_type == UserType.kOwner){
                self.lblAbn.text = kData?.aBN
                self.address.text = kData?.address
                self.viewHeightConstraint.constant = 132
                self.abnView.isHidden = false
            } else {
                self.abnView.isHidden = true
                self.lblAbn.text = ""
                self.address.text = ""
                self.viewHeightConstraint.constant = 0
            }
            
            self.userName.text = "\(kData?.first_name ?? "") \(kData?.last_name ?? "")"
            self.company.text = kData?.company
            self.userType.text = kData?.user_type
        
        }
    }
    

    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        let vc = ScreenManager.getController(storyboard: .projectStatus, controller: EditProfileVC()) as! EditProfileVC
        vc.abn = self.lblAbn.text ?? ""
        vc.address = self.address.text ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
