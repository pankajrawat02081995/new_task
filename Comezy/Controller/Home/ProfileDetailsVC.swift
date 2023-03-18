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
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        email.text = kUserData!.email!
        phoneNumber.text = kUserData!.phone!
        occupation.text = kUserData!.occupation!.name!
       
        if let url = URL(string: (kUserData?.profile_picture)!){
            userImage.kf.setImage(with: url)
            userImage.contentMode = .scaleAspectFill
        }
        userName.text = "\(String(describing: kUserData!.first_name!.capitalized))"+" "+"\(String(describing:kUserData!.last_name!.capitalized))"
        company.text = kUserData!.company!
        userType.text = kUserData!.user_type!


        
    }
    

    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        let vc = ScreenManager.getController(storyboard: .projectStatus, controller: EditProfileVC()) as! EditProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
