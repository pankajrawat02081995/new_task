//
//  PaymentMethodSelectionVC.swift
//  Comezy
//
//  Created by Lalit Kumar on 24/05/23.
//

import UIKit

class PaymentMethodSelectionVC: UIViewController {

    
    @IBOutlet weak var imgStripeChecl: UIImageView!
    
    @IBOutlet weak var imgPaypalCheck: UIImageView!
    
    
    var selectedMethod = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnStripeClicked(_ sender: UIButton) {
        self.imgStripeChecl.image = UIImage.init(named: "ic_check")
        self.imgPaypalCheck.image = UIImage.init(named: "ic_uncheck")
        self.selectedMethod = "1"
    }
    
    @IBAction func btnPaypalClicked(_ sender: UIButton) {
        self.imgStripeChecl.image = UIImage.init(named: "ic_uncheck")
        self.imgPaypalCheck.image = UIImage.init(named: "ic_check")
        self.selectedMethod = "2"
    }
    
    @IBAction func btnPaynowClicked(_ sender: UIButton) {
        checkSubscribe?.subscribe(type: self.selectedMethod)
        self.dismiss(animated: true)
    }
    
    
}
