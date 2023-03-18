//
//  VariationReceiversCell.swift
//  Comezy
//
//  Created by aakarshit on 31/05/22.
//

import UIKit

class VariationReceiversCell: UITableViewCell {
    var xMarkCallback: (() -> Void)?
    var checkMarkCallback: (() -> Void)?
    var statusLabelCallback: (() -> Void)?
    
    @IBOutlet weak var xMark: UIImageView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var receiverEmail: UILabel!
    @IBOutlet weak var receiverImage: UIImageView!
    @IBOutlet weak var responseStatusLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        receiverImage.layer.cornerRadius = receiverImage.height / 2
        receiverImage.layer.borderWidth = 3
        receiverImage.layer.borderColor = UIColor(named: "AppBrightGreenColor")?.cgColor
        
        let xMarkTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(xMarkImageTapped(tapGestureRecognizer:)))
           xMark.isUserInteractionEnabled = true
           xMark.addGestureRecognizer(xMarkTapRecognizer)
        
        let statusLabelTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusLabelTapped(tapGestureRecognizer:)))
            responseStatusLabel.isUserInteractionEnabled = true
            responseStatusLabel.addGestureRecognizer(statusLabelTapRecognizer)
        
        let checkMarkTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkMarkImageTapped(tapGestureRecognizer:)))
        checkMark.isUserInteractionEnabled = true
        checkMark.addGestureRecognizer(checkMarkTapRecognizer)
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func xMarkImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
            print("hello")
            xMarkCallback?()
        // Your action
    }
    
    @objc func checkMarkImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("hello from the check mark side")
        checkMarkCallback?()
    }
    
    @objc func statusLabelTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("Label Tapped")
        statusLabelCallback?()
    }

}
