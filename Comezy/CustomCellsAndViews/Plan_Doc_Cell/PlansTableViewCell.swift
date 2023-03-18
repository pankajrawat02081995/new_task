//
//  PlansTableViewCell.swift
//  Comezy
//
//  Created by MAC on 02/08/21.
//

import UIKit

class PlansTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPlanHeading: UILabel!
    @IBOutlet weak var lblPlanDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
