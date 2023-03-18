//
//  ClientDetailsCell.swift
//  Comezy
//
//  Created by shiphul on 24/11/21.
//

import UIKit

class ClientDetailsCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item:CResult?{
        didSet{
            self.nameLbl?.text = (item?.first_name ?? "") + " " + (item?.last_name ?? "")
            self.emailLbl?.text = item?.email
            if item?.profile_picture == ""{
                imgView.image = UIImage(named: "userImg.png")
            }else{
            self.imgView.image = item?.profile_picture as? UIImage
            }
            }
    }
    
    var item2: WorkersResult?{
        didSet{
            nameLbl.text = (item2?.firstName ?? "") + " " + (item2?.lastName ?? "")
            emailLbl.text = item2?.email
            if item2?.profilePicture == ""{
                imgView.image = UIImage(named: "userImg.png")
                
            }else{
                imgView.image = UIImage(named: item2?.profilePicture ?? "")
            }
        }
    
}
}
