//
//  TimesheetCell.swift
//  Comezy
//
//  Created by shiphul on 29/12/21.
//

import UIKit

class TimesheetCell: UITableViewCell {
    var editImageCallback: (() -> Void)?
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStartIn: UILabel!
    @IBOutlet weak var lblOut: UILabel!
    @IBOutlet weak var editButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var btnEdit: UIImageView!
    @IBOutlet weak var lblHour: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let editMarkTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(editImageTaped(tapGestureRecognizer:)))
           btnEdit.isUserInteractionEnabled = true
        btnEdit.addGestureRecognizer(editMarkTapRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func editImageTaped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
            print("hello")
         editImageCallback?()
        // Your action
    }
    
    var item: TimesheetListModelResult?{
        didSet{
//            let dateFormatter = DateFormatter()
//            let tempLocale = dateFormatter.locale // save locale temporarily
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let date = dateFormatter.date(from: item?.dateAdded ?? "")!
//            dateFormatter.dateFormat = "d MMM "
//            dateFormatter.locale = tempLocale // reset the locale
//            let dateString = dateFormatter.string(from: date)
//            lblDate.text = dateString
            lblDate.text = DateFormatToAnother(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "d MMM ", date: item?.dateAdded ?? "")
            lblStartIn.text = DateFormatToAnother(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "hh:mm aa", date: item?.startTime ?? "")
            print(item?.startTime)
            lblOut.text = DateFormatToAnother(inputFormat: "yyyy-MM-dd HH:mm:ss", outputFormat: "hh:mm aa", date: item?.endTime ?? "")
            lblHour.text = item?.workedHours
            
            
        }

    }
    
}
