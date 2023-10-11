//
//  ResumeProjectCell.swift
//  Comezy
//
//  Created by aakarshit on 25/07/22.
//

import UIKit

class ResumeProjectCell: UITableViewCell {
    var resumeCallback: (() -> Void)?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnResume: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnResume.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnResume_action(_ sender: Any) {
        resumeCallback?()
    }
    
}
