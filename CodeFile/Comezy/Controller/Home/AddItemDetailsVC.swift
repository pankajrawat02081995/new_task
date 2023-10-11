//
//  AddItemDetailsVC.swift
//  Comezy
//
//  Created by Lalit Kumar on 18/06/23.
//

import UIKit

class AddItemDetailsVC: UIViewController {
    
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtQuanity: UITextField!
    @IBOutlet weak var lblTotal: UILabel!
    
    
    var name = "",
    callBack:((_ item: ItemsList?)->())?
    
    var currentIndex = 0
    var model : ItemsList?
    var isUpdate : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        if isUpdate == true{
            self.txtPrice.text = self.model?.amount
            self.txtQuanity.text = "\(self.model?.quantity ?? 0)"
            self.lblItemName.text = self.model?.name
        }else{
            self.lblItemName.text = name
        }
        self.txtQuanity.delegate = self
    }
    
    
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        if self.txtPrice.text?.isEmpty == true {
            self.showAlert(message: "Please enter price")
        } else if self.txtQuanity.text?.isEmpty == true {
            self.showAlert(message: "Please enter quantity")
        } else{
            let req = ItemsList(name: lblItemName.text ?? "", amount: txtPrice.text ?? "", quantity: Int(txtQuanity.text ?? "") ?? 0, hasValue: true, currency: "USD")
            
            self.dismiss(animated: true) {
                self.callBack?(req)
                reloadData?.reload()
            }
            
        }
    }
    

    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
   

}


extension AddItemDetailsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.txtPrice.text?.isEmpty == false {
            let price = Float(self.txtPrice.text ?? "") ?? 0
            let quanity = Float(self.txtQuanity.text ?? "") ?? 0
            let total = Int(price) * Int(quanity)
            self.lblTotal.text = "Total: - \(String(total))"
        }
        
    }
}
