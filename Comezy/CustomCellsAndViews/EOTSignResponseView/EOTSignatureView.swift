//
//  EOTSignatureView.swift
//  Comezy
//
//  Created by aakarshit on 23/06/22.
//

import UIKit

class EOTSignatureView: UIViewController {
    var callback: ((_ imgUrl: String) -> Void)?
    var sigImage = UIImage()
    
    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var sigImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSign.addDashedBorder()
        
    }
    
    //       init() {
    //       super.init(nibName: "EOTSignatureView", bundle: Bundle(for: EOTSignatureView.self))
    //       self.modalPresentationStyle = .overCurrentContext
    //       self.modalTransitionStyle = .crossDissolve
    //       }
    //       required init?(coder: NSCoder) {
    //       fatalError("init(coder:) has not  been implemented")
    //       }
    
    @IBAction func submit_action(_ sender: Any) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        
        if sigImage != UIImage() {
            AWSS3Manager.shared.uploadImage(image: sigImage, fileName: "\(AWSFileDirectory.PUBLIC)signatureImages/signature_\(timestamp)") { (progress) in
                self.showProgressHUD()
                
            } completion: { (resp, error) in
                self.hideProgressHUD()
                if error == nil {
                    print(String(describing: resp))
                    self.callback?(resp as! String)
                    //                    self.callSocialSignup(image: String(describing: resp!))
                }else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
            
            print("btnSubmitPressed")
        } else {
            self.showAlert(message: "Please add signature")
        }
    }
    
    @IBAction func cancel_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnClear_action(_ sender: Any) {
        sigImage = UIImage()
        sigImageView.image = nil
        
    }
    
    @IBAction func btnSign_action(_ sender: Any) {
        print("BtnSign pressed")
        let vc = ScreenManager.getController(storyboard: .main, controller: SignaturePadVC()) as! SignaturePadVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.callBack = {(img: UIImage) in
            DispatchQueue.main.async {
                self.sigImage = img
                self.sigImageView.image = img
                
            }
            
        }
        // self.navigationController?.pushViewController(vc, animated: true)
     self.present(vc, animated: true, completion: nil)
    }
    
    
    
}
