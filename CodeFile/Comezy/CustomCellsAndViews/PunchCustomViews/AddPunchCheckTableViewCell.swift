//
//  AddPunchCheckTableViewCell.swift
//  Comezy
//
//  Created by aakarshit on 20/06/22.
//

import UIKit

class AddPunchCheckTableViewCell: UITableViewCell, UITextFieldDelegate {
    var cancelCallback: (()->Void)?
    var didEndEditCallback: ((_:String)->Void)?
    @IBOutlet weak var punchTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        punchTextField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnCancel_action(_ sender: Any) {
        cancelCallback?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            didEndEditCallback?("")
        } else {
            didEndEditCallback?(punchTextField.text!)
        }
    }
    
}
