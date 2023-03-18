//
//  SiteRiskBannerCell.swift
//  Comezy
//
//  Created by prince on 25/01/23.
//

import UIKit

class SiteRiskBannerCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var serialNumberlbl: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
