//
//  File.swift
//  Comezy
//
//  Created by aakarshit on 24/05/22.
//

import Foundation
import UIKit

class AllPeopleCell: UITableViewCell {
    
    //MARK: - Variable
    ///IB Outlet of view controller
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblWorkerName: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblWorkerEmail: UILabel!
    var item: AllPeopleListElement?{
        didSet{
            lblWorkerName.text = "\(String(describing: item!.firstName)) \(String(describing: item!.lastName))"
            
            lblOccupation.text = item?.userType
            lblWorkerEmail.text = item?.email
            if item?.profilePicture == ""{
                imgProfile.image = UIImage(named: "userImg.png")
                
            } else {
                if let url = URL(string: (item?.profilePicture)!){
                    imgProfile.kf.setImage(with: url)
                    imgProfile.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    //MARK: - UI table view lifecycler
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.layer.cornerRadius = imgProfile.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
