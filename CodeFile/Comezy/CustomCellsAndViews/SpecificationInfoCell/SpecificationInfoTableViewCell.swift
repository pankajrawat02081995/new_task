//
//  SpecificationInfoTableViewCell.swift
//  Comezy
//
//  Created by amandeepsingh on 05/07/22.
//

import UIKit

class SpecificationInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSpecifiactioName: UILabel!
    @IBOutlet weak var lblSpecifiactionDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
