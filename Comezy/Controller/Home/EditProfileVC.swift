//
//  EditProfileVC.swift
//  Comezy
//
//  Created by amandeepsingh on 02/08/22.
//

import UIKit

class EditProfileVC: UIViewController {

    //MARK: - Variables
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var occupation: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
 
    var imgName:String?
    var imageFile:String?

    var objProfileViewModel = EditProfileViewModel()
    //MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        let cameraClick: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageClick(_:)))
        camera.isUserInteractionEnabled = true
        camera.addGestureRecognizer(cameraClick)

    }
    override func viewWillAppear(_ animated: Bool) {
        phone.text = kUserData!.phone!
        occupation.text = kUserData!.occupation!.name!
       
        if let url = URL(string: (kUserData?.profile_picture)!){
            userImage.kf.setImage(with: url)
            userImage.contentMode = .scaleAspectFill
        }
        firstName.text = "\(String(describing: kUserData!.first_name!.capitalized))"
        lastName.text = "\(String(describing: kUserData!.last_name!.capitalized))"
        company.text = kUserData!.company!
        imageFile = kUserData?.profile_picture ?? ""

    }
    
    //MARK: - Button Click Action Method

    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    @IBAction func btnUpdateAction(_ sender: Any) {
        self.objProfileViewModel.updateProfile(firstName: self.firstName.text!, lastName: self.lastName.text!, phone: self.phone.text!, occupation: 1, company: self.company.text!, profilePicture: self.imageFile!){ success, editProfile , errorMsg in
            if(success){
                self.navigationController?.popViewController(animated: true)
            self.showToast(message: "Profile Detail Updated successfully", font: .boldSystemFont(ofSize: 14.0))
                kUserData?.first_name = editProfile!.firstName
                kUserData?.last_name = editProfile!.lastName
                kUserData?.phone = editProfile!.phone

                kUserData?.profile_picture = editProfile!.profilePicture
                kUserData?.company = editProfile!.company
                kUserData?.occupation?.name = editProfile!.occupation.name
                kUserData?.occupation?.id = editProfile!.occupation.id
                kUserData?.profile_picture = editProfile!.profilePicture

                
            }
        }
}
    @objc func imageClick(_ sender: UITapGestureRecognizer){
        showImagePickerOptionSingle()
    }
    
    //MARK: - User Defined Function
    //Method to Picker Image
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

