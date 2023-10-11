//
//  DocsCell.swift
//  Comezy
//
//  Created by shiphul on 03/12/21.
//

import UIKit

class DocsCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item:Item) {
       cellLabel.text = item.text
       cellImage.image = item.image
    }
    func configureCellDaily(item2: DailysItem){
        cellLabel.text = item2.text
        cellImage.image = item2.image
     }
    
}
