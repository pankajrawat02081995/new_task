//
//  ScheduledTaskCell.swift
//  Comezy
//
//  Created by amandeepsingh on 08/08/22.
//

import UIKit

class ScheduledTaskCell: UITableViewCell {


    @IBOutlet weak var btnTodayDate: UIButton!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTaskName: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnTodayDate.layer.cornerRadius = btnTodayDate.width / 2
        btnTodayDate.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
