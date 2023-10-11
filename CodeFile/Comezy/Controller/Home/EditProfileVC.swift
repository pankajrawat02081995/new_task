//
//  EditProfileVC.swift
//  Comezy
//
//  Created by amandeepsingh on 02/08/22.
//

import UIKit
import DropDown
class EditProfileVC: UIViewController {
    
    //MARK: - Variables
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var occupation: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var viewABn: UIView!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtAbn: UITextField!
    var occPicker = UIPickerView()
    var myOccList = [Occupaton]()
    let objSignupViewModel = SignupViewModel()
    var selectedOccId = 0
    var abn = ""
    var address = ""
    var imgName:String?
    var imageFile:String?
    
    var objProfileViewModel = EditProfileViewModel()
    //MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        let cameraClick: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageClick(_:)))
        self.camera.isUserInteractionEnabled = true
        self.camera.addGestureRecognizer(cameraClick)
        self.occupation.isUserInteractionEnabled = true
        self.occupation.delegate = self
        self.getOccupation()
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
    override func viewWillAppear(_ animated: Bool) {
        self.phone.text = kUserData!.phone!
        self.occupation.text = kUserData!.occupation!.name!
        self.selectedOccId = kUserData!.occupation!.id!
        
        if let url = URL(string: (kUserData?.profile_picture)!){
            userImage.kf.setImage(with: url)
            userImage.contentMode = .scaleAspectFill
        }
        self.firstName.text = "\(String(describing: kUserData!.first_name!.capitalized))"
        self.lastName.text = "\(String(describing: kUserData!.last_name!.capitalized))"
        self.company.text = kUserData!.company!
        self.imageFile = kUserData?.profile_picture ?? ""
        
        
        self.txtAbn.text = self.abn
        self.txtAddress.text = self.address
        
        if(kUserData?.user_type == UserType.kOwner){
            self.viewHeightConstraint.constant = 120
            self.viewABn.isHidden = false
        }else{
            self.viewHeightConstraint.constant = 0
            self.viewABn.isHidden = true
        }
        
    }
    
    //MARK: - Button Click Action Method
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        
        if self.firstName.text?.isEmpty == true {
            self.showAlert(message: FieldValidation.kFirstNameEmpty)
        } else if self.lastName.text?.isEmpty == true {
            self.showAlert(message: FieldValidation.kLastNameEmpty)
        } else if phone.text?.isEmpty == true {
            self.showAlert(message: FieldValidation.kPhoneEmpty)
        } else if self.phone.text?.count ?? 0 < 10 || self.phone.text?.count ?? 0 > 13 {
            self.showAlert(message: FieldValidation.kValidPhone)
        } else if self.company.text?.isEmpty == true {
            self.showAlert(message: FieldValidation.kCompanyNameEmpty)
        }  else if self.txtAbn.text?.isEmpty == true &&  kUserData?.user_type == UserType.kOwner{
            self.showAlert(message: "Enter AVN number")
        } else if self.txtAbn.text?.count ?? 0 != 11 && kUserData?.user_type == UserType.kOwner{
            self.showAlert(message: "Enter valid AVN number")
        } else if self.txtAddress.text?.isEmpty == true && kUserData?.user_type == UserType.kOwner {
            self.showAlert(message: "Enter address.")
        } else {
            self.objProfileViewModel.updateProfile(firstName: self.firstName.text!, lastName: self.lastName.text!, phone: self.phone.text!, occupation: self.selectedOccId, company: self.company.text!, profilePicture: self.imageFile!, abn: self.txtAbn.text ?? "", address: self.txtAddress.text ?? ""){ success, editProfile , errorMsg in
                if(success){
                    self.navigationController?.popViewController(animated: true)
                    self.showToast(message: "Profile Detail Updated successfully", font: .boldSystemFont(ofSize: 14.0))
                    kUserData?.first_name = editProfile!.firstName
                    kUserData?.last_name = editProfile!.lastName
                    kUserData?.phone = editProfile!.phone
                    
                    kUserData?.profile_picture = editProfile!.profilePicture
                    kUserData?.company = editProfile!.company
                    kUserData?.occupation?.name = self.occupation.text ?? ""
                    kUserData?.occupation?.id = editProfile!.occupation.id
                    kUserData?.profile_picture = editProfile!.profilePicture
                    
                }
            }
        }
        
        
    }
    
    
    @objc func imageClick(_ sender: UITapGestureRecognizer){
        showImagePickerOptionSingle()
    }
    
    //MARK: - User Defined Function
    func imagePickerSingle(sourceType: UIImagePickerController.SourceType)->UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    //Method to Show Image Picker Option
    func showImagePickerOptionSingle(){
        let alertVC = UIAlertController(title:fileUploadPopUp.kUploadFile,message: fileUploadPopUp.kChooseAOption, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: fileUploadPopUp.kTakeAPhoto, style: .default){
            [weak self] (action) in
            guard let self = self else {
                return
            }
            
            let cameraImagePicker = self.imagePickerSingle(sourceType: .camera)
            cameraImagePicker.delegate=self
            
            self.present(cameraImagePicker, animated: true){
            }
        }
        let libraryAction = UIAlertAction(title: fileUploadPopUp.kChooseFromGallery, style: .default){
            [weak self] (action) in
            guard let self = self else {
                return
            }
            
            let libraryImagePicker = self.imagePickerSingle(sourceType: .photoLibrary)
            libraryImagePicker.delegate=self
            self.present(libraryImagePicker, animated: true){
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC,animated: true,completion: nil)
        
    }
}
//MARK: - Extension AddProjectVC For Image Picker Controller
extension EditProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        var uploadUrls = [URL]()
        
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userImage.image = image
        
        
        imgName = String("IMG_\(Date().millisecondsSince1970).png")
        print("Image_NAME------>",imgName)
        let imgName = String("IMG_\(Date().millisecondsSince1970).png")
        
        let documentDirectory = NSTemporaryDirectory()
        
        let localPath = documentDirectory.appending(imgName)
                
        let data = image?.jpegData(compressionQuality: 0.3)! as! NSData
        
        data.write(toFile: localPath, atomically: true)
        
        let photoURL = URL.init(fileURLWithPath: localPath)
        
        uploadUrls.append(photoURL)
        
        uploadFile(urls: photoURL)
        
        
    }
    func uploadFile(urls:URL){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = DateTimeFormat.kDateTimeFormat
        let timestamp = format.string(from: date)
        showProgressHUD(message: "")
        //arrayPath = urls
        AWSS3Manager.shared.uploadImageFile(fileUrl: urls, fileName: "\(AWSFileDirectory.PUBLIC)\(AWSFileDirectory.PROFILE_FOLDER)/\(AWSFileDirectory.PROFILE_IMAGE)\(urls.lastPathComponent)") { (progress) in
            print(progress)
        } completion: { [self] (resp, error) in
            if error == nil {
                self.hideProgressHUD()
                
                let file = resp as! String
                self.imageFile = file
                print(imageFile!)
                
                self.showToast(message: "image uploaded successfully", font: .boldSystemFont(ofSize: 14.0))
                
                self.view.layoutIfNeeded()
            } else {
                self.showAlert(message: error?.localizedDescription ?? "")
            }
        }
    }
    
}


extension EditProfileVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.occupation{
            textField.resignFirstResponder()
            let dropDown = DropDown()
            let dropDownValues = myOccList.map { occ in
                occ.name ?? ""
            }
            
            dropDown.anchorView = textField
            
            dropDown.dataSource = dropDownValues
            dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                selectedOccId = myOccList[index].id ?? 1
                occupation.text = item
                //            if item == "Builder" {
                //                self.viewHeightConstraint.constant = 180
                //                self.viewAbn.isHidden = false
                //            } else {
                //                self.viewHeightConstraint.constant = 0
                //                self.viewAbn.isHidden = true
                //            }
                print(selectedOccId)
            }
        }
    }
}
