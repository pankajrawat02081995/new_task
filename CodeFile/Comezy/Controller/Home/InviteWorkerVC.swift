//
//  InviteWorkerVC.swift
//  Comezy
//
//  Created by aakarshit on 28/07/22.
//

import UIKit
import FirebaseDynamicLinks

class InviteWorkerVC: UIViewController {
    
    var objVM = InviteWorkerViewModel()
    var objInvMailVM = InviteMailViewModel()
    var is_worker_invited = false

    let allPeopleList = AllPeopleListViewModel.shared.allPeopleListDataDetail
    var projectId:Int?
    var ownerName: String?
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hideKeyboardWhenTappedAround()
        super.viewDidAppear(true)
        ownerName = (kUserData?.first_name ?? "") + " " + (kUserData?.last_name ?? "")
    }
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnInvite_action(_ sender: Any) {
        objVM.inviteWorker(firstName: txtFirstName.text ?? "", lastName: txtLastName.text ?? "", email: txtEmail.text ?? "", type: UserType.kWorker, projectId: projectId ?? 0, inductionURL: K.inductionURL, phone: txtPhone.text ?? "") { sucess, response, error in
            if sucess {
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
                let projectId = URLQueryItem(name: "project_id", value: "\(response?.projectID ?? 0)")
                let induction_url = URLQueryItem(name: "induction_url", value: "\(response?.inductionURL ?? "")")
                let ownerName = URLQueryItem(name: "owner_name", value: self.ownerName)
                components.queryItems = [firstName, lastName, type, email, phone, inviteId, projectId, induction_url, ownerName]
                
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
                
                shareLink.shorten { url, warnings, error in
                    if let error = error {
                        print("Error Occured! \(error)")
                        return
                    }
                    
                    if let warnings = warnings {
                        for warning in warnings {
                            print("FDL Warning: \(warning)")
                        }
                    }
                    
                    guard let shortLinkURl = url else {
                        return
                    }
                    print("Short Url \(url)")
                    self.objInvMailVM.sendInviteMail(inviteId: "\(response?.id ?? 0)", inviteLink: shortLinkURl.absoluteString) { success, response, message in
                        if success {
                            self.is_worker_invited = true
                            self.showShareSheet(url: shortLinkURl)
                            print(message)
                        }
                    }
                    
                }
                
                
                
                self.showToast(message: "Worker Invitation sent successfully")
            } else {
                self.showToast(message: error ?? "Error Occured please try again later.")
            }
        }
    }
    func showShareSheet(url: URL) {
        let shareText = "Hi, you have been invited to sign up on the build ezi app!"
        let activityVC = UIActivityViewController(activityItems: [shareText, url], applicationActivities: nil)
        present(activityVC, animated: true, completion: { () in
            if(self.is_worker_invited){
                self.backTwo()
            } })
    }
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}
