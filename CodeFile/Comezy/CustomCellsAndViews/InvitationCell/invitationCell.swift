//
//  invitationCell.swift
//  Comezy
//
//  Created by aakarshit on 25/07/22.
//

import UIKit

class invitationCell: UITableViewCell {

    @IBOutlet weak var lblWorkerName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
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
