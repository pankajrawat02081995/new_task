//
//  PunchCheckListTableViewCell.swift
//  Comezy
//
//  Created by aakarshit on 17/06/22.
//

import UIKit

class PunchCheckListTableViewCell: UITableViewCell {
    var callback: (()->Void)?
    @IBOutlet weak var btnUnComplete: UIButton!
    @IBOutlet weak var punchLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnUnComplete_action(_ sender: Any) {
        callback?()
    }
}
