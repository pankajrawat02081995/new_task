//
//  DailyLogCell.swift
//  Comezy
//
//  Created by shiphul on 23/12/21.
//

import UIKit
import Kingfisher




class DailyLogCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var item: DailyLogResult?{
        didSet{
            let dateFormatter = DateFormatter()
            let tempLocale = dateFormatter.locale // save locale temporarily
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: item?.createdTime ?? "")!
            dateFormatter.dateFormat = "EE, MMMM d"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            print("EXACT_DATE : \(dateString)")
            lblDate.text = dateString
            lblLocation.text = item?.location?.name
            lblDescription.text = item?.notes
//            let url = URL(string: (item?.weather?.icon)!)
//            imgWeather.kf.setImage(with: url, placeholder: nil, options: nil)
            //Uploaded from getImage() Method
            imgWeather.image = UIImage(named: item?.weather?.getImage() ?? "02d")


        }

    }

}

