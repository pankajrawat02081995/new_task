//
//  InviteClientVC.swift
//  Comezy
//
//  Created by aakarshit on 28/07/22.
//

import UIKit
import FirebaseDynamicLinks

class InviteClientVC: UIViewController{
    
    var objVM = InviteClientViewModel()
    var is_client_invited = false
    var objInvMailVM = InviteMailViewModel()
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        
    }

    
    
    @IBAction func btnBack_action(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnInvite_action(_ sender: Any) {
        
        objVM.invitePerson(firstName: txtFirstName.text ?? "", lastName: txtLastName.text ?? "", email: txtEmail.text ?? "", type: UserType.kClient, phone: txtPhone.text ?? "") { success, error, response in
            if success {
                var components = URLComponents()
                components.scheme = "http"
                components.host = "buildezi.com"
                components.path = "/"
                
                let firstName = URLQueryItem(name: "first_name", value: response?.firstName)
                let lastName = URLQueryItem(name: "last_name", value: response?.lastName)
                let phone = URLQueryItem(name: "contact", value: self.txtPhone.text ?? "")
                let type = URLQueryItem(name: "type", value: response?.userType)
                let email = URLQueryItem(name: "email", value: response?.email)
                let inviteId = URLQueryItem(name: "invited_id", value: "\(response?.id ?? 0)")
                components.queryItems = [firstName, lastName, type, phone, email, inviteId]
                guard let linkParameter = components.url else {return}
                print("The Link is ->", linkParameter.absoluteString)
                
                guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: K.dynamicLinkPrefix) else {
                    print("Couldn't create FDL components")
                    return
                }
                
                if let myBundleId = Bundle.main.bundleIdentifier {
                    shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
                }
                shareLink.iOSParameters?.appStoreID = K.appStoreId
                shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: K.androidPackageName)
                
                guard let longURL = shareLink.url else { return }
                print("The long dynamic link is \(longURL.absoluteString)")
                
                shareLink.shorten { inviteURL , warnings, error in
                    if let error = error {
                        print("Error Occured! \(error)")
                        return
                    }
                    
                    if let warnings = warnings {
                        for warning in warnings {
                            print("FDL Warning: \(warning)")
                        }
                    }
                    
                    guard let url = inviteURL  else {
                        return
                    }
                    
                    self.objInvMailVM.sendInviteMail(inviteId: "\(response?.id ?? 0)", inviteLink: url.absoluteString) { success, response, message in
                        if success {
                            self.is_client_invited = true
                            self.showShareSheet(url: url)
                            print(message)
                        }
                    }
                    print("Short Url \(url)")
                }
                self.showToast(message: "Client Invitation sent successfully")
            } else {
                self.showToast(message: error ?? "An error occured!")
            }
        }
    }
    func showShareSheet(url: URL) {
        let shareText = "Hi, you have been invited to sign up on the build ezi app!"
        let activityVC = UIActivityViewController(activityItems: [shareText, url], applicationActivities: nil)
        present(activityVC, animated: true, completion: { () in
                    if(self.is_client_invited){
            self.navigationController?.popViewController(animated: true)
                    } })
    }
}
