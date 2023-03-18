//
//  InductionQuestionCell.swift
//  Comezy
//
//  Created by aakarshit on 29/07/22.
//

import UIKit

class InductionQuestionCell: UITableViewCell {
    var noCallBack: (()->())?
    var yesCallBack: (()->())?
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblQuestionDescription: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var stackResponseBtns: UIStackView!
    @IBOutlet weak var questionToBottomConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnYes.createGradLayer()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnNo_action(_ sender: Any) {
        noCallBack?()
    }
    @IBAction func btnYes_action(_ sender: Any) {
        yesCallBack?()
    }
}
