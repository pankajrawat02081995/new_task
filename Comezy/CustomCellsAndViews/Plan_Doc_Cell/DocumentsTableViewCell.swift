//
//  DocumentsTableViewCell.swift
//  Comezy
//
//  Created by MAC on 02/08/21.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgDoc: UIImageView!
    @IBOutlet weak var lblDocumentHeading: UILabel!
    @IBOutlet weak var lblDocumentDetails: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
