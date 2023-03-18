//
//  SubscribeVC.swift
//  Comezy
//
//  Created by amandeepsingh on 06/08/22.
//
import UIKit

class SubscribeVC: UIViewController{
var objSubscriptionViewModel = SubscribeViewModel()
    var IS_SUBSCRIPTION:String = ""
    
    @IBOutlet weak var backgroudView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btnBuyNowAction(_ sender: UIButton) {
        subscrbeNow()
    }
    func subscrbeNow(){
        if(IS_SUBSCRIPTION != "NO_ACTIVE_PLAN"){
            createSubscription()
        }else{
        self.objSubscriptionViewModel.getSubscriptionId()
    { success, response, message in
    if success {
        
        print(response![0].subscription)
        self.reactiveSubscription(subscriptionId: response![0].subscription)
    }
        
        else{
            self.showToast(message: message!)

        }
    }
        }
    }
    func createSubscription(){
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print(futureDate)
        var context = [
            "return_url" : "https://example.com/returnUrl",
            "cancel_url": "https://example.com/cancelUrl"
        ]
        var date = "\(getFormattedDate(dateFormatt: "yyyy-MM-dd'T'", date: futureDate!))00:00:00Z"
        objSubscriptionViewModel.createSubscription(planId: AppConstant.SUBSCRIPTION_PLAN_ID, startTime:date, applicationContext: context) { success, response, message in
            if success {
               // self.showShareSheet(url: url)
                print(message)
                let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
                vc.docURL = response?.links[0].href
                vc.subscriptionId = response?.id
                vc.isFromSubscribe = true
              //  self.showToast(message: "Subscribed successfully")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                print(message)
                self.showToast(message: message ?? "")
            }
        }
    }
    func reactiveSubscription(subscriptionId:String){
        objSubscriptionViewModel.reActivateSubscription(subscriptionId: subscriptionId) { success, response, message in
            if success {
                self.showToast(message: "Subscribed successfully")
                self.navigationController?.popViewController(animated: true)
            }
            else{
                print(message)
                self.showToast(message: message ?? "")
            }
        }
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

