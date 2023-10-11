//
//  DailyInvoiceListTblCell.swift
//  Comezy
//
//  Created by Lalit Kumar on 20/08/23.
//

import UIKit

class DailyInvoiceListTblCell: UITableViewCell {
    
    @IBOutlet weak var lblInvoiceId: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPrivce: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
