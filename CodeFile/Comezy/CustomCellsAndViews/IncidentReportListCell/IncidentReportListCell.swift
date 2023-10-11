//
//  IncidentReportListCell.swift
//  Comezy
//
//  Created by aakarshit on 30/06/22.
//

import UIKit

class IncidentReportListCell: UITableViewCell {

    @IBOutlet weak var lblIncidentDescription: UILabel!
    @IBOutlet weak var lblIncidentType: UILabel!
    @IBOutlet weak var lblIncidentDate: UILabel!
    @IBOutlet weak var lblIncidentReportedDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
