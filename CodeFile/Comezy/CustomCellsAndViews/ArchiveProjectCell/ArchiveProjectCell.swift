//
//  ArchiveProjectCell.swift
//  Comezy
//
//  Created by aakarshit on 22/07/22.
//

import UIKit

class ArchiveProjectCell: UITableViewCell {
    var btnCallback: (()-> Void)?
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnChangeStatus: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnChangeStatus_action(_ sender: Any) {
        btnCallback?()
    }
    
}
