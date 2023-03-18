//
//  SignupVC.swift
//  Comezy
//
//  Created by MAC on 09/07/21.
//

import UIKit
import SignaturePad
import iOSPhotoEditor
import MobileCoreServices
import DropDown

class SignupVC: UIViewController {
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtOccupation: UITextField!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCpassword: UITextField!
    @IBOutlet weak var signaturePad: SignaturePad!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomSigntoTopSignupBtnConstraint: NSLayoutConstraint!
    @IBOutlet weak var inductionStackView: UIStackView!
    @IBOutlet weak var btnSignature: UIButton!
    @IBOutlet weak var signatureTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnInduction: UIButton!
    
    @IBOutlet weak var btnSelectOccupation: UIButton!
    @IBOutlet weak var btnSafetyCard: UIButton!
    @IBOutlet weak var btnTradingLicense: UIButton!
    
    
    let objSignupViewModel = SignupViewModel()
    var myOccList = [Occupaton]()
    var objInductionQuestionsVM = InductionQuestionsViewModel()
    var occPicker = UIPickerView()
    var selectedOccId = 0
    var sigImage = UIImage()
    var userDetail = UserDataModel()
    var invitedPerson: InvitePersonModel?
    var ownerObj: AllPeopleListElement?
    var inductionCompleted = false
    var imageName: String?
    var safetyCardUrl: String?
    var tradingCardUrl: String?
    var arrayPath: URL?
    var isTradingLicense = false
    var isSafetyCard = false
    var safetyCard: String?
    var tradingCard: String?
    var arrayOfInductionResponse: [[String: Any]]?
    var isSocialLogin = false
    
    @IBOutlet weak var pwdStackHeight: NSLayoutConstraint!
    @IBOutlet weak var cpwdStackHeight: NSLayoutConstraint!
    @IBOutlet weak var imgSignature: UIImageView!
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false // or true
        super.viewDidLoad()
        invitedPerson = globalInvitedPerson
        print(invitedPerson?.inviteId)
        initialLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isSocialLogin {
            isSocialLogin = false
            inductionStackView.isHidden = true
            bottomSigntoTopSignupBtnConstraint.constant = 20
            
        } else {
            if invitedPerson?.userType == UserType.kWorker {
                inductionStackView.isHidden = false
                bottomSigntoTopSignupBtnConstraint.constant = 350
                txtFullName.text = (invitedPerson?.firstName ?? "")
                txtLastName.text = (invitedPerson?.lastName ?? "")
                txtPhoneNumber.text = (invitedPerson?.phone ?? "")

                txtEmail.text = invitedPerson?.email
                
            } else if invitedPerson?.userType == UserType.kClient  {
                inductionStackView.isHidden = true
                bottomSigntoTopSignupBtnConstraint.constant = 20
                txtFullName.text = (invitedPerson?.firstName ?? "")
                txtLastName.text = (invitedPerson?.lastName ?? "")
                print(invitedPerson?.phone)
                txtPhoneNumber.text = (invitedPerson?.phone ?? "")
                txtEmail.text = invitedPerson?.email
            } else {
                inductionStackView.isHidden = true
                bottomSigntoTopSignupBtnConstraint.constant = 20
            }

        }
        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hideNavBar()
    }
    
    @IBAction func addOccupation(_ sender: Any) {
        let vc = AddCommentViewController()
        vc.show()
        vc.btnPost.setTitle("Add", for: .normal)
        vc.lblComment.text = "Add Occupation"
        vc.commentTextField.text = "Write Occupation name here"
        vc.callback = {
            if vc.commentTextField.text == "Write Occupation name here" || vc.commentTextField.text == "" || vc.commentTextField.text == "Please enter occupation name here!!" {
                vc.commentTextField.text = "Please enter occupation name here!!"
            } else {
                self.objSignupViewModel.addOccupation(name: vc.commentTextField.text) { success, model, errorMsg in
                    if success {
                        self.getOccupation()
                        self.showToast(message: "Occupation added successully.")
                    } else {
                        self.showToast(message: errorMsg ?? "An error occured!")
                    }
                }
                vc.dismiss(animated: true)
            }
            
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("rootViewController ->", self.navigationController?.rootViewController?.className)
        print("ViewControllers on SignUp ->",self.navigationController?.viewControllers)
        print("windows ->",    UIApplication.shared.windows)
    }
    
    @IBAction func signUp_action(_ sender: Any) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = DateTimeFormat.kDateTimeFormat
        let timestamp = format.string(from: date)
        
        if isFromDynamicLink {
            if invitedPerson?.userType == UserType.kWorker {
                if inductionCompleted {
                    if sigImage != UIImage() {
                        print(sigImage)
                    self.showProgressHUD()
                        AWSS3Manager.shared.uploadImage(image: sigImage, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.SIGNATURE_FOLDER)/\(AWSFileDirectory.SIGNATURE_IMAGE)\(timestamp)") { (progress) in
                        } completion: { (resp, error) in
                            self.hideProgressHUD()
                            if error == nil {
                                self.callWorkerSignup(image: String(describing: resp!))
                            }else {
                                self.showAlert(message: error?.localizedDescription ?? "")
                            }
                        }
                    } else {
                        self.callClientSignup(image: "")
                    }
                } else {
                    self.showToast(message: "Please complete the induction")
                }
                
            }
            if invitedPerson?.userType == UserType.kClient {
                if sigImage != UIImage() {
                    print(sigImage)
                    self.showProgressHUD()
                    AWSS3Manager.shared.uploadImage(image: sigImage, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.SIGNATURE_FOLDER)/\(AWSFileDirectory.SIGNATURE_IMAGE)\(timestamp)") { (progress) in
                    } completion: { (resp, error) in
                        self.hideProgressHUD()
                        if error == nil {
                            self.callClientSignup(image: String(describing: resp!))
                        }else {
                            self.showAlert(message: error?.localizedDescription ?? "")
                        }
                    }
                } else {
                    self.callClientSignup(image: "")
                }
            }
            
        } else {
            if userDetail.userEmail != nil {
                if sigImage != UIImage() {
                    self.showProgressHUD()
                    AWSS3Manager.shared.uploadImage(image: sigImage, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.SIGNATURE_FOLDER)/\(AWSFileDirectory.SIGNATURE_IMAGE)\(timestamp)") { (progress) in
                        
                    } completion: { (resp, error) in
                        self.hideProgressHUD()
                        if error == nil {
                            print(String(describing: resp))
                            self.callSocialSignup(image: String(describing: resp!))
                        }else {
                            self.showAlert(message: error?.localizedDescription ?? "")
                        }
                    }
                }else {
                    
                    self.callSocialSignup(image: "")
                }
            }else {
                if sigImage != UIImage() {
                    print(sigImage)
                    self.showProgressHUD()
                    AWSS3Manager.shared.uploadImage(image: sigImage, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.SIGNATURE_FOLDER)/\(AWSFileDirectory.SIGNATURE_IMAGE)\(timestamp)") { (progress) in
                    } completion: { (resp, error) in
                        self.hideProgressHUD()
                        if error == nil {
                            self.callSignup(image: String(describing: resp!))
                        }else {
                            self.showAlert(message: error?.localizedDescription ?? "")
                        }
                    }
                }else {
                    callSignup(image: "")
                }
            }
        }
        
        
    }
    
    @IBAction func clearSignature_action(_ sender: Any) {
        
    }
    @IBAction func btnSelectOccupation_action(_ sender: UIButton) {
        let dropDown = DropDown()
        let dropDownValues = myOccList.map { occ in
            occ.name ?? ""
        }
        
        dropDown.anchorView = sender
        
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            selectedOccId = myOccList[index].id ?? 1
            txtOccupation.text = item
            print(selectedOccId)
        }
    }
    
    @IBAction func signature_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: SignaturePadVC()) as! SignaturePadVC
        vc.callBack = {(img: UIImage) in
            self.sigImage = img
            self.imgSignature.image = img
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnUploadSafety_action(_ sender: Any) {
        isSafetyCard = true
        showImagePickerOption(delegate:self)
        
    }
    @IBAction func btnUploadTradingLic_action(_ sender: Any) {
        isTradingLicense = true
        showImagePickerOption(delegate:self)
        
    }
    
    @IBAction func btnInduction_action(_ sender: UIButton!) {
        let vc = ScreenManager.getController(storyboard: .main, controller: InductionQuestionsVC()) as! InductionQuestionsVC
        vc.ownerObj = ownerObj
        vc.inductionResponseCallback = { response in
            self.arrayOfInductionResponse = response
        }
        vc.callback = { bool in
            if bool {
                sender.backgroundColor = .systemGreen
                sender.setTitle("Induction Complete", for: .normal)
                sender.isUserInteractionEnabled = false
                self.inductionCompleted = true
                print("Called green on button")
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func back_action(_ sender: Any) {
        if isFromDynamicLink == true {
            isFromDynamicLink = false
        }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- Custom Functions -
extension SignupVC {
    func initialLoad() {
        btnSelectOccupation.setTitle("", for: .normal)
        txtFullName.attributedPlaceholder = NSAttributedString(string: "Enter your first name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        txtLastName.attributedPlaceholder = NSAttributedString(string: "Enter your last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        txtPhoneNumber.attributedPlaceholder = NSAttributedString(string: "Enter your phone number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter your email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        txtOccupation.attributedPlaceholder = NSAttributedString(string: "Enter your occupation", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        txtCompanyName.attributedPlaceholder = NSAttributedString(string: "Enter your company name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        txtCpassword.attributedPlaceholder = NSAttributedString(string: "Enter confirm password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 9808306)])
        self.hideNavBar()
        self.btnSignUp.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnSignUp.clipsToBounds = true
//        occPicker.delegate = self
//        occPicker.dataSource = self
        txtOccupation.delegate = self
//        txtOccupation.inputView = occPicker
        getOccupation()
        print("get occupation called")
        
        modifyUI()
        
        print("modifyUICalled")
        
    }
    
    func modifyUI(){
        if userDetail.userEmail != nil && userDetail.firstName != "" && userDetail.lastName != "" && userDetail.userEmail != "" {
            txtFullName.text = userDetail.firstName
            txtLastName.text = userDetail.lastName
            txtEmail.text = userDetail.userEmail
            txtFullName.isUserInteractionEnabled = false
            txtLastName.isUserInteractionEnabled = false
            txtEmail.isUserInteractionEnabled = false
            pwdStackHeight.constant = 0
            cpwdStackHeight.constant = 0
            signatureTopConstraint.constant = 30
        } else if userDetail.userEmail != nil && userDetail.firstName == ""  {
            txtFullName.isUserInteractionEnabled = true
            txtLastName.isUserInteractionEnabled = true
            txtEmail.isUserInteractionEnabled = true
            pwdStackHeight.constant = 0
            cpwdStackHeight.constant = 0
            signatureTopConstraint.constant = 30
            txtFullName.text = userDetail.firstName
            txtLastName.text = userDetail.lastName
            txtEmail.text = userDetail.userEmail
        } else {
            txtFullName.isUserInteractionEnabled = true
            txtLastName.isUserInteractionEnabled = true
            txtEmail.isUserInteractionEnabled = true
//            pwdStackHeight.constant = 0
//            cpwdStackHeight.constant = 0
            signatureTopConstraint.constant = 200
            txtFullName.text = userDetail.firstName
            txtLastName.text = userDetail.lastName
            txtEmail.text = userDetail.userEmail
        }
    }
    
    
    
    func callSignup(image: String) {
        self.objSignupViewModel.getsignupDetails(signupType: "", controller: self, first_name: self.txtFullName.text ?? "", last_name: self.txtLastName.text ?? "", user_type: UserType.kOwner, email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", cpassword: self.txtCpassword.text ?? "", phone: self.txtPhoneNumber.text ?? "", facebook_token: "", apple_token: "", google_token: "", occupation: self.selectedOccId, company: self.txtCompanyName.text ?? "", signature: image) { (success, message, type) in
            if success {
                
                
                AppDelegate.shared.setSlideMenuController(.notifications)
            } else {
                self.showAlert(message: message)
            }
        }
    }
    
    func callWorkerSignup(image: String) {

        self.objSignupViewModel.inviteWorkerSignupPressed(controller: self, first_name: self.txtFullName.text ?? "", last_name: self.txtLastName.text ?? "", user_type: UserType.kWorker, email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", cpassword:  self.txtCpassword.text ?? "", phone: self.txtPhoneNumber.text ?? "", occupation:  self.selectedOccId, company: self.txtCompanyName.text ?? "", signature: image, safetyCard: safetyCardUrl ?? "", tradingLicense: tradingCardUrl ?? "", inviteId: Int(invitedPerson?.inviteId ?? "0") ?? 0) { sucess, user, eror, type in
            if sucess {
                print(user?.jwt_token)
                self.objInductionQuestionsVM.sendInductionResponse(jwt: user?.jwt_token ?? "", response: self.arrayOfInductionResponse ?? []) { success, resp, errorMsg in
                    if success {
                        AppDelegate.shared.setSlideMenuController(.notifications)
                        isFromDynamicLink = false
                    } else {
                        self.showToast(message: errorMsg ?? "An error occured! Please try again later.")
                    }
                }
                
            } else {
                self.showAlert(message: eror)
            }
       }
    }
    
    func callClientSignup(image: String) {
        self.objSignupViewModel.inviteClientSignupPressed(controller: self, first_name: self.txtFullName.text ?? "", last_name: self.txtLastName.text ?? "", user_type: UserType.kClient, email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", cpassword:  self.txtCpassword.text ?? "", phone: self.txtPhoneNumber.text ?? "", occupation:  self.selectedOccId, company: self.txtCompanyName.text ?? "", signature: image, inviteId: Int(invitedPerson?.inviteId ?? "0") ?? 0) { sucess, eror, type in
            if sucess {
                AppDelegate.shared.setSlideMenuController(.notifications)
                isFromDynamicLink = false
            } else {
                self.showAlert(message: eror)
            }
        }
    }
    
    func callSocialSignup(image: String) {
        if self.userDetail.socialType == "google" {
            self.objSignupViewModel.getsignupDetails(signupType: "socialSignup", controller: self, first_name: self.txtFullName.text ?? "", last_name: self.txtLastName.text ?? "", user_type: UserType.kOwner, email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", cpassword: self.txtCpassword.text ?? "", phone: self.txtPhoneNumber.text ?? "", facebook_token: "", apple_token: "", google_token: self.userDetail.socialLoginId ?? "", occupation: self.selectedOccId, company: self.txtCompanyName.text ?? "", signature: image) { (success, message, type) in
                if success {
                    AppDelegate.shared.setSlideMenuController(.notifications)
                }else {
                    self.showAlert(message: message)
                }
            }
        }else if self.userDetail.socialType == "fb"{
            self.objSignupViewModel.getsignupDetails(signupType: "socialSignup", controller: self, first_name: self.txtFullName.text ?? "", last_name: self.txtLastName.text ?? "", user_type: UserType.kOwner, email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", cpassword: self.txtCpassword.text ?? "", phone: self.txtPhoneNumber.text ?? "", facebook_token: self.userDetail.socialLoginId ?? "", apple_token: "", google_token: "", occupation: self.selectedOccId, company: self.txtCompanyName.text ?? "", signature: image) { (success, message, type) in
                if success {
                    AppDelegate.shared.setSlideMenuController(.notifications)
                } else {
                    self.showAlert(message: message)
                }
            }
        }else {
            self.objSignupViewModel.getsignupDetails(signupType: "socialSignup", controller: self, first_name: self.txtFullName.text ?? "", last_name: self.txtLastName.text ?? "", user_type: UserType.kOwner, email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", cpassword: self.txtCpassword.text ?? "", phone: self.txtPhoneNumber.text ?? "", facebook_token: "", apple_token: self.userDetail.socialLoginId ?? "", google_token: "", occupation: self.selectedOccId, company: self.txtCompanyName.text ?? "", signature: image) { (success, message, type) in
                if success {
                    AppDelegate.shared.setSlideMenuController(.notifications)
                }else {
                    self.showAlert(message: message)
                }
            }
        }
        
    }
    
    func getOccupation() {
        
        self.objSignupViewModel.getOccupationList { (success, occList, error) in
            if success {
                self.myOccList = occList?.results ?? [Occupaton]()
                self.myOccList.remove(at: 0)
                DispatchQueue.main.async {
                    self.occPicker.reloadAllComponents()
                }
            }else {
                self.showAlert(message: error)
            }
        }
    }
    
    

    
    
}

////MARK:- PickerView delegates and datasource -
//extension SignupVC: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return myOccList.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return myOccList[row].name ?? ""
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        txtOccupation.text = myOccList[row].name ?? ""
//        selectedOccId = myOccList[row].id ?? 0
//    }
//}

//MARK:- SignaturePad delegates -
extension SignupVC: SignaturePadDelegate {
    func didStart() {
        scrollView.isScrollEnabled = false
    }
    
    func didFinish() {
        scrollView.isScrollEnabled = true
        sigImage = signaturePad.getSignature() ?? UIImage()
    }
    
}


//MARK: - Extension AddROIVC For Image Picker Controller
extension SignupVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, PhotoEditorDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        
        var uploadUrls = [URL]()
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let imgName = "IMG_\(String(Date().millisecondsSince1970)).png"
        
        imageName = imgName
        
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        
        //PhotoEditorDelegate
        photoEditor.photoEditorDelegate = self
        
        //The image to be edited
        photoEditor.image = image
        
        //Stickers that the user will choose from to add on the image
        //        photoEditor.stickers.append(UIImage(named: "sticker" )!)
        
        //Optional: To hide controls - array of enum control
        photoEditor.hiddenControls = [.share, .save, .sticker, .crop]
        
        //Optional: Colors for drawing and Text, If not set default values will be used
        photoEditor.colors = [.red, .yellow, .orange, .green, .brown, .magenta, .gray, .cyan, .blue, .lightGray, .purple, .systemIndigo, .systemPink, .systemTeal]
        
        //Present the View Controller
        photoEditor.modalPresentationStyle = .fullScreen
        navigationController?.present(photoEditor, animated: true, completion: nil)
    }
    
    func doneEditing(image: UIImage) {
        
        let documentDirectory = NSTemporaryDirectory()
        if let safeImageName = imageName {
            let localPath = documentDirectory.appending(safeImageName)
            
            
            
            let data = image.jpegData(compressionQuality: 0.3)! as NSData
            
            data.write(toFile: localPath, atomically: true)
            
            let photoURL = URL.init(fileURLWithPath: localPath)
            
            var uploadUrls = [URL]()
            
            
            uploadUrls.append(photoURL)
            
            uploadFile(urls: uploadUrls)
        }
        
    }
    
    func canceledEditing() {
        print("Canceled")
    }
    
}

//MARK: Document Picker
extension SignupVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        uploadFile(urls: urls)
    }
    func uploadFile(urls:[URL]){
        if isSafetyCard {
            isSafetyCard = false
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = DateTimeFormat.kDateTimeFormat
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls[0])
            arrayPath = urls[0]
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.SAFETY_CARD_FOLDER)\(AWSFileDirectory.SAFETY_CARD_FILE)\(arrayPath!.lastPathComponent)") { (progress) in
                
                print(progress)
            } completion: { (resp, error) in
                if error == nil {
                    self.hideProgressHUD()
                    
                    let file = resp as! String
                    //                        if self.selectedIndex == nil{
                    //                            self.selectedIndex = nil
                    //                        self.arrayOfAddedFilesURL.append(file)
                    //                        } else {
                    //                            self.arrayOfAddedFiles.remove(at: self.selectedIndex!)
                    //                            self.arrayOfAddedFilesURL.insert(file, at: self.selectedIndex!)
                    //                        }
                    
                    
                    
                    
                    self.safetyCardUrl = file
                    
                    self.safetyCard = (urls[0].lastPathComponent)
                    print(self.safetyCard, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    print(self.safetyCardUrl, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    self.btnSafetyCard.setTitle(self.safetyCard, for: .normal)
                    
                    //                    self.stackViewHeightConstraint.constant = CGFloat(70 * self.arrayOfAddedVariations.count)
                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
        
        if isTradingLicense {
            isTradingLicense = false
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = DateTimeFormat.kDateTimeFormat
            let timestamp = format.string(from: date)
            showProgressHUD(message: "")
            print("urls[0]", urls[0])
            arrayPath = urls[0]
            AWSS3Manager.shared.uploadImageFile(fileUrl: urls[0], fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.TRADING_LICENSE_FOLDER)\(AWSFileDirectory.TRADING_LICENSE_FILE)\(arrayPath!.lastPathComponent)") { (progress) in
                
                print(progress)
            } completion: { (resp, error) in
                if error == nil {
                    self.hideProgressHUD()
                    
                    let file = resp as! String
                    //                        if self.selectedIndex == nil{
                    //                            self.selectedIndex = nil
                    //                        self.arrayOfAddedFilesURL.append(file)
                    //                        } else {
                    //                            self.arrayOfAddedFiles.remove(at: self.selectedIndex!)
                    //                            self.arrayOfAddedFilesURL.insert(file, at: self.selectedIndex!)
                    //                        }
                    
                    
                    
                    
                    self.tradingCardUrl = file
                    
                    self.tradingCard = (urls[0].lastPathComponent)
                    print(self.tradingCard, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    print(self.tradingCardUrl, "@#$@#$%@#$%#$%#$ A R R A Y  ADDED $#%@#$%@#$%@#$")
                    self.btnTradingLicense.setTitle(self.tradingCard, for: .normal)
                    
                    //                    self.stackViewHeightConstraint.constant = CGFloat(70 * self.arrayOfAddedVariations.count)
                    self.view.layoutIfNeeded()
                } else {
                    self.showAlert(message: error?.localizedDescription ?? "")
                }
            }
        }
        
        
    }
}

extension SignupVC: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == txtOccupation {
//            if txtOccupation.text == "" {
//                let firstElement = myOccList.first
//                if let safeElement = firstElement, let safeId = safeElement.id {
//                    txtOccupation.text = safeElement.name
//                    selectedOccId = safeId
//                } else {
//                    showToast(message: "Unable to load occupations list, please check internet connection & refresh by going back.")
//                }
//            }
//        }
//    }
}
