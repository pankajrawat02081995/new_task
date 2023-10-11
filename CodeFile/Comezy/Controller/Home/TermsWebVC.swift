//
//  TermsWebVC.swift
//  Comezy
//
//  Created by aakarshit on 29/07/22.
//

import UIKit
import WebKit

class TermsWebVC: UIViewController, WKUIDelegate {
    @IBOutlet weak var viewForWeb: WKWebView!
   
    @IBOutlet weak var lblOwnerName: UILabel!
    var docURL: String?
        
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        viewForWeb.uiDelegate = self
//    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewForWeb.uiDelegate = self
        let ownerNameArr = globalInvitedPerson?.ownerName?.split(separator: "+")
        lblOwnerName.text = (ownerNameArr?[0] ?? "") + " " + (ownerNameArr?[1] ?? "" )
        let myURL = URL(string: K.inductionURL)
        
        //MARK: Optional not getting unwrapped here
        if let safeURL = myURL {
            let myRequest = URLRequest(url: safeURL)
            viewForWeb.load(myRequest)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
