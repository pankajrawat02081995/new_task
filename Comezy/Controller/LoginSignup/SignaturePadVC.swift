//
//  SignaturePadVC.swift
//  Comezy
//
//  Created by archie on 10/11/21.
//

import UIKit
import SignaturePad

class SignaturePadVC: UIViewController,SignaturePadDelegate {

  
    @IBOutlet weak var signaturePad: SignaturePad!
    var isFromEOT=false
    var sigImg = UIImage()
    var callBack: ((_ img: UIImage)-> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signaturePad.delegate = self
        // Do any additional setup after loading the view.
    }
    func didStart() {
       }

       func didFinish() {
        sigImg = signaturePad.getSignature() ?? UIImage()
       }
        
   
    @IBAction func save_action(_ sender: Any) {
        callBack?(sigImg)
       self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func clearSignature_action(_ sender: Any) {
        signaturePad.clear()
    }
    
}
