//
//  TasksListCell.swift
//  Comezy
//
//  Created by shiphul on 18/12/21.
//

import UIKit
import SDWebImage

class TasksListCell: UITableViewCell {

    @IBOutlet weak var ImgUser: UIImageView!
    @IBOutlet weak var lblWorkerName: UILabel!
    @IBOutlet weak var lblWorkerEmail: UILabel!
    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var txtTaskDeatils: UITextField!
    @IBOutlet weak var txtStrart_Date: UITextField!
    @IBOutlet weak var txtEnd_Date: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var item2: TaskResult?{
        didSet{
            lblWorkerName.text = (item2?.assignedWorker?.firstName ?? "") + " " + (item2?.assignedWorker?.lastName ?? "")
            lblWorkerEmail.text = item2?.assignedWorker?.email
            txtTaskName.text = item2?.taskName
            txtTaskDeatils.text = item2?.resultDescription
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: item2?.startDate ?? "")!
            dateFormatter.dateFormat = "EE, MMMM d"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            print("EXACT_DATE : \(dateString)")
            txtStrart_Date.text = dateString
            let dateFormatter2 = DateFormatter()
            let tempLocale2 = dateFormatter2.locale // save locale temporarily
            dateFormatter2.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date2 = dateFormatter2.date(from: item2?.endDate ?? "")!
            dateFormatter2.dateFormat = "EE, MMM d"
            dateFormatter2.locale = tempLocale // reset the locale
            let dateString2 = dateFormatter.string(from: date2)
            print("EXACT_DATE : \(dateString2)")
            txtEnd_Date.text = dateString2
           
            if item2?.assignedWorker?.profilePicture == ""{
                ImgUser.image = UIImage(named: "userImg.png")

            }else{
                 ImgUser.sd_setImage(with: URL(string: item2?.assignedWorker?.profilePicture ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
            }
        }

    }

    
}

