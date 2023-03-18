//
//  WebViewVC.swift
//  Comezy
//
//  Created by shiphul on 13/12/21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKUIDelegate, WKNavigationDelegate {

   
    @IBOutlet weak var viewForWeb: WKWebView!
    var objSubscribeView = SubscribeViewModel()
   
    var docURL: String?
    var subscriptionId:String?
    var isFromSubscribe:DarwinBoolean?
    
    @IBOutlet weak var webViewTitle: UILabel!
    //    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        viewForWeb.uiDelegate = self
//    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewForWeb.uiDelegate = self
        viewForWeb.navigationDelegate = self;

        let myURL = URL(string:docURL ?? "")
        print(myURL)
        
        
        //MARK: Optional not getting unwrapped here 
        if let safeURL = myURL {
            let myRequest = URLRequest(url: myURL!)
            viewForWeb.load(myRequest)

        }
          
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if (isFromSubscribe==true) {
            webViewTitle.text = "Subscribe"
            isFromSubscribe = false
        }else{
            webViewTitle.text = "Document"


        }
    }
 
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHome_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: HomeVC()) as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")

        if let url = webView.url?.absoluteString{
            if(url.contains(AppConstant.RETURN_URL)){
                objSubscribeView.sendSubscribedUser(subscriptionId: subscriptionId!){ success, response, message in
                    if success {
                       // self.showShareSheet(url: url)
                        print(message)
                        self.showToast(message: "Subscribed Successfully")
                        let defaults = UserDefaults.standard
                        defaults.set(self.subscriptionId, forKey: "subscriptionId")
                        let vc = ScreenManager.getController(storyboard: .main, controller: HomeVC()) as! HomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        print(message)
                        self.showToast(message: message ?? "")
                    }
                }
            }
        }
    }


}
//extension WebViewVC: WKNavigationDelegate, WKUIDelegate {
//    func webView(_: WKWebView, didFinish _: WKNavigation!) {
//        // Web view loaded
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        // Show error view
//    }
//
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        // Show error view
//    }
//}
