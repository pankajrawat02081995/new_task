
//
//  DKLeftMenuCell.swift
//  Doctalkgo
//
//  Created by Jitendra Kumar on 12/08/20.
//  Copyright © 2020 Jitendra Kumar. All rights reserved.
//

import UIKit

class DKLeftMenuCell: UITableViewCell {
    
    @IBOutlet weak var iconView:UIImageView!
    @IBOutlet weak var titlelbl:UILabel!
    @IBOutlet weak var lblNotificationCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isHighlighted: Bool{
        didSet{
            self.contentView.backgroundColor = isHighlighted ?  UIColor.blue.withAlphaComponent(0.1) : .clear
        }
    }
    override var isSelected: Bool{
        didSet{
            self.contentView.backgroundColor = isSelected ?  UIColor.blue.withAlphaComponent(0.1) : .clear
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
}
