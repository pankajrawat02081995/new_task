//
//  PeopleTableViewCell.swift
//  Comezy
//
//  Created by MAC on 02/08/21.
//

import UIKit
import WebKit

class PeopleTableViewCell: UITableViewCell {
    var removeWorkerCallback: (() -> Void)?
    var phoneNumberCallback: (() -> Void)?
    @objc var inductionResponseCallback: (() -> Void)?


    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblWorkerName: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    
    @IBOutlet weak var btnSeeCompletedInduction: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    var item: PeopleClient?{
        didSet{
            lblWorkerName.text = "\(String(describing: item!.firstName!)) \(String(describing: item!.lastName!))"
            lblOccupation.text = item?.occupation?.name
            
            btnPhone.setTitle(item?.phone, for: .normal)
            if let url = URL(string:(item?.profilePicture)!){
                imgProfile.kf.setImage(with: url)
                imgProfile.contentMode = .scaleAspectFill
            } else {
                imgProfile.image = UIImage(named: "userImg.png")
            }
        }
    }
    
    @IBAction func btnPhoneAction(_ sender: UIButton) {
        phoneNumberCallback?()
    }
    var itemClient:CResult?{
        didSet{
            self.lblWorkerName?.text = (itemClient?.first_name ?? "") + " " + (itemClient?.last_name ?? "")
            self.lblOccupation?.text = itemClient?.email
            btnPhone.setTitle(itemClient?.phone, for: .normal)

            if itemClient?.profile_picture == ""{
                imgProfile.image = UIImage(named: "userImg.png")
            }else{
                if let url = URL(string: (itemClient?.profile_picture)!){
                    imgProfile.kf.setImage(with: url)
                    imgProfile.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    var item2: WorkersResult?{
        didSet{
            lblWorkerName.text = (item2?.firstName ?? "") + " " + (item2?.lastName ?? "")
            lblOccupation.text = item2?.email
            btnPhone.setTitle(item2?.phone, for: .normal)
            if item2?.profilePicture == ""{
                imgProfile.image = UIImage(named: "userImg.png")
                
            }else{
                if let url = URL(string: (item2?.profilePicture)!){
                    imgProfile.kf.setImage(with: url)
                    imgProfile.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    @IBAction func btnRemoveAction(_ sender: UIButton) {
        removeWorkerCallback?()
    }
    

    @IBAction func btnSeeCompleted(_ sender: UIButton) {
        inductionResponseCallback?()

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let origImage = UIImage(named: "ic_cancel")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        btnRemove.setImage(tintedImage, for: .normal)
        btnRemove.tintColor = .black
        btnRemove.setTitle("", for: .normal)
     
        
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
