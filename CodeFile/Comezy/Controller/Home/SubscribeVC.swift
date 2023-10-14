////
////  SubscribeVC.swift
////  Comezy
////
////  Created by amandeepsingh on 06/08/22.
////
//import UIKit
////import StripePaymentSheet
////import StripePaymentsUI
//
//
//protocol CheckSubscribe {
//    func subscribe(type: String)
//}
//
//var checkSubscribe: CheckSubscribe?

import UIKit
class SubscribeVC: UIViewController{
}
//
//    var objSubscriptionViewModel = SubscribeViewModel()
//    
//    var IS_SUBSCRIPTION:String = ""
//    // var paymentIntentClientSecret = "pi_3NAxh5SDldGfqgHq0GczGKyN_secret_bEyqxP8YIeir0RLJcBlEKzBpi"
//    
////    var paymentSheet: PaymentSheet?
//    let backendCheckoutUrl = URL(string: "http://api.buildezi.com:8001/accountspayments/create/payment_intent")!
//    
//    var urlValue = ""
//    
//    
////    lazy var cardTextField: STPPaymentCardTextField = {
////        let cardTextField = STPPaymentCardTextField()
////        return cardTextField
////    }()
//    
//    
//    @IBOutlet weak var backgroudView: UIView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        checkSubscribe = self
//        
////        var configuration = PaymentSheet.Configuration()
//        configuration.returnURL = "Comezy://stripe-redirect"
//        
//        let fullName = UserDefaults.standard.value(forKey: "FullName") ?? ""
//        let email = UserDefaults.standard.value(forKey: "email") ?? ""
//        
//        let params: [String: Any] = ["customer_name": fullName,
//                                     "customer_email": email]
//        
//        var request = URLRequest(url: backendCheckoutUrl)
//        request.httpMethod = "POST"
//        
//        let paramsData = try? JSONSerialization.data(withJSONObject: params)
//        
//        request.httpBody = paramsData
//        
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
//            
//            guard let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
//                  let customerId = json["customer"] as? String,
//                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
//                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
//                  let publishableKey = json["publishableKey"] as? String,
//                  let self = self else {
//                // Handle error
//                return
//            }
//            
//            STPAPIClient.shared.publishableKey = publishableKey
//            // MARK: Create a PaymentSheet instance
//            var configuration = PaymentSheet.Configuration()
//            configuration.merchantDisplayName = "Comezy, Inc."
//            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
//            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
//            // methods that complete payment after a delay, like SEPA Debit and Sofort.
//            configuration.allowsDelayedPaymentMethods = true
//            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
//            
//            //              DispatchQueue.main.async {
//            //                self.checkoutButton.isEnabled = true
//            //              }
//        })
//        task.resume()
//    }
//    
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.createCheckoutSession()
//    }
//    
//    
//    
//    @IBAction func btnBuyNowAction(_ sender: UIButton) {
//        let vc = ScreenManager.getController(storyboard: .projectStatus, controller: PaymentMethodSelectionVC()) as! PaymentMethodSelectionVC
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: true)
//       // subscrbeNow()
//    }
//    
//    func subscrbeNow(){
//        if(IS_SUBSCRIPTION != "NO_ACTIVE_PLAN"){
//            createSubscription()
//        }else{
//            self.objSubscriptionViewModel.getSubscriptionId()
//            { success, response, message in
//                if success {
//                    
//                    print(response![0].subscription)
//                    self.reactiveSubscription(subscriptionId: response![0].subscription)
//                }
//                
//                else{
//                    self.showToast(message: message!)
//                    
//                }
//            }
//        }
//    }
//    
//    func createSubscription(){
//        let currentDate = Date()
//        var dateComponent = DateComponents()
//        dateComponent.day = 1
//        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
//        var context = [
//            "return_url" : "https://example.com/returnUrl",
//            "cancel_url": "https://example.com/cancelUrl"
//        ]
//        var date = "\(getFormattedDate(dateFormatt: "yyyy-MM-dd'T'", date: futureDate!))00:00:00Z"
//        objSubscriptionViewModel.createSubscription(planId: AppConstant.SUBSCRIPTION_PLAN_ID, startTime:date, applicationContext: context) { success, response, message in
//            if success {
//                // self.showShareSheet(url: url)
//                print(message)
//                let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
//                vc.docURL = response?.links[0].href
//                vc.subscriptionId = response?.id
//                vc.isFromSubscribe = true
//                //  self.showToast(message: "Subscribed successfully")
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            else{
//                print(message)
//                self.showToast(message: message ?? "")
//            }
//        }
//    }
//    
//    func reactiveSubscription(subscriptionId:String){
//        objSubscriptionViewModel.reActivateSubscription(subscriptionId: subscriptionId) { success, response, message in
//            if success {
//                self.showToast(message: "Subscribed successfully")
//                self.navigationController?.popViewController(animated: true)
//            }
//            else{
//                print(message)
//                self.showToast(message: message ?? "")
//            }
//        }
//    }
//    @IBAction func btnBackAction(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//
////MARK: - CUSTOM DELEGATE
//extension SubscribeVC: CheckSubscribe {
//    func subscribe(type: String) {
//        if type == "1" {
//            let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
//            vc.docURL = self.urlValue          // vc.subscriptionId = response?.id
//            vc.isFromSubscribe = true
//            //  self.showToast(message: "Subscribed successfully")
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        } else if type == "2"{
//            self.subscrbeNow()
//        }
//    }
//    
//    
//    //    func pay() {
//    ////            guard let paymentIntentClientSecret = paymentIntentClientSecret else {
//    ////                return
//    ////            }
//    //            // Collect card details
//    //            let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
//    //            paymentIntentParams.paymentMethodParams = cardTextField.paymentMethodParams
//    //
//    //            // Submit the payment
//    //            let paymentHandler = STPPaymentHandler.shared()
//    //            paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
//    //                switch (status) {
//    //                case .failed:
//    //                    //self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
//    //                    //self.showAlert(message: error?.localizedDescription)
//    //                    print(error?.localizedDescription)
//    //                    break
//    //                case .canceled:
//    //                    //self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
//    //                    break
//    //                case .succeeded:
//    //                    //self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
//    //                    break
//    //                @unknown default:
//    //                    fatalError()
//    //                    break
//    //                }
//    //            }
//    //        }
//    
//    
//    
//    func didTapCheckoutButton() {
//        // MARK: Start the checkout process
//        paymentSheet?.present(from: self) { paymentResult in
//            // MARK: Handle the payment result
//            switch paymentResult {
//            case .completed:
//                print("Your order is confirmed")
//            case .canceled:
//                print("Canceled!")
//            case .failed(let error):
//                print("Payment failed: \(error)")
//            }
//        }
//    }
//    
//}
//
//
//
//extension SubscribeVC: STPAuthenticationContext {
//    func authenticationPresentingViewController() -> UIViewController {
//        return self
//    }
//}
//
//
////MARK: - STRIPE
//extension SubscribeVC {
//    func createStripeSubscription(){
//        let currentDate = Date()
//        var dateComponent = DateComponents()
//        dateComponent.day = 1
//        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
//        var context = [
//            "return_url" : "http://ec2-3-21-238-163.us-east-2.compute.amazonaws.com:8001/accountspayments/stipe_success/",
//            "cancel_url": "http://ec2-3-21-238-163.us-east-2.compute.amazonaws.com:8001/accountspayments/stripe_cancel/"
//        ]
//        var date = "\(getFormattedDate(dateFormatt: "yyyy-MM-dd'T'", date: futureDate!))00:00:00Z"
//        //        objSubscriptionViewModel.createSubscription(planId: AppConstant.SUBSCRIPTION_PLAN_ID, startTime:date, applicationContext: context) { success, response, message in
//        //            if success {
//        //               // self.showShareSheet(url: url)
//        //                print(message)
//        //                let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
//        //                vc.docURL = response?.links[0].href
//        //                vc.subscriptionId = response?.id
//        //                vc.isFromSubscribe = true
//        //              //  self.showToast(message: "Subscribed successfully")
//        //                self.navigationController?.pushViewController(vc, animated: true)
//        //            }
//        //            else{
//        //                print(message)
//        //                self.showToast(message: message ?? "")
//        //            }
//        //        }
//    }
//    
//    
//    
//    func createCheckoutSession() {
//        let Url = String(format: "http://api.buildezi.com:8001/accountspayments/create_checkout_session")
//        guard let serviceUrl = URL(string: Url) else { return }
//        
//        let fullName = UserDefaults.standard.value(forKey: "FullName") ?? ""
//        let email = UserDefaults.standard.value(forKey: "email") ?? ""
//        let parameterDictionary = ["customer_email" : email,
//                                   "cuastomer_name": fullName]
//        var request = URLRequest(url: serviceUrl)
//        request.httpMethod = "POST"
//        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
//            return
//        }
//        request.httpBody = httpBody
//        
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
//            if let data = data {
//                do {
//                    
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        print(json)
//                        // try to read out a string array
//                        if let jsonData = json["data"] as? [String: Any] {
//                            print(jsonData)
//                            if let redirectUrl = jsonData["redirect_url"] as? String {
//                                print(redirectUrl)
//                                self.urlValue = redirectUrl
//                                
//                            }
//                        }
//                    }
//                    
//                    
//                } catch {
//                    print(error)
//                }
//            }
//        }.resume()
//    }
//}
