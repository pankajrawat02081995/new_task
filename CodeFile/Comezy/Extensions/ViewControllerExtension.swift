//
//  ViewControllerExtension.swift
//  InsuranceCalculator
//
//  Created by MAC on 29/04/20.
//  Copyright © 2020 MAC. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import SafariServices
import MobileCoreServices


private var progressHUD: MBProgressHUD?
extension UIViewController {
    
    
    func navigationBarTitle(headerTitle:String = "", backTitle backtitle:String = "") {
     //   self.navigationItem.backBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_back"), style: .plain, target: nil, action: nil)
        self.navigationItem.backButtonTitle = ""
        if self.className == LandingVC.className || self.className == HomeVC.className {
            self.navigationController?.navigationBar.isHidden = true
        }else{
            navigationItem.title = headerTitle
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    func hideNavBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- MBProgredHUD -
    func showProgressHUD(message:String? = nil) {
        let topView = self.navigationController?.topViewController
        print("Navigation Controller ->", self.navigationController?.restorationIdentifier)
        if let topView = topView {
            topView.view.endEditing(true)
            hideProgressHUD()
            progressHUD = nil
            progressHUD = MBProgressHUD.showAdded(to: topView.view, animated: true)
            
            if let message = message {
                progressHUD?.label.text = message
                progressHUD?.label.numberOfLines = 0
            }
        }

    }

    
    func hideProgressHUD() {
        if let progressHUD = progressHUD {
            progressHUD.hide(animated: true)
        }
    }
    
    //MARK:- Alert -
    func showAlert(message:String? = nil)  {
        
        let alertController = UIAlertController(title: App.name, message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAppAlert(title: String, message: String, okCallback: @escaping (() -> Void)) {
        let vc = ConfirmViewController()
        vc.show()
        vc.confirmHeadingLabel?.text = title
        vc.confirmDescriptionLabel?.text = message
        vc.callback = okCallback
    }
    
    func showWarningAppAlert(title: String, message: String, okCallBack: @escaping (() -> Void)) {
        let vc = ConfirmViewController()
        vc.confirmHeadingLabel?.text = title
        vc.btnYes.titleLabel?.textColor = .red
        vc.confirmDescriptionLabel.text = message
        vc.callback = okCallBack
    }
    
    func showWorkInProgress() {
        let vc = ConfirmViewController()
        vc.show()
        vc.btnNo?.centerXToSuperview()
        vc.btnYes?.isHidden = true
        vc.confirmHeadingLabel?.text = "Work in progress"
        vc.confirmDescriptionLabel?.text = "The work is in progress, kindly visit again later"
        vc.btnNo?.setTitle("Ok", for: .normal)
    }
    
    func showMessageWithOk(title: String, message: String) {
        let vc = ConfirmViewController()
        vc.show()
        vc.btnNo?.centerXToSuperview()
        vc.btnYes?.isHidden = true
        vc.confirmHeadingLabel?.text = title
        vc.confirmDescriptionLabel?.text = message
        vc.btnNo?.setTitle("Ok", for: .normal)
    }
    
    func showAlert(message:String? = nil, okCallback:@escaping () -> Void) {
        let alertController = UIAlertController(title: App.name, message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (_ ) in
            okCallback()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertCustomMessage(title:String? = nil,message:String? = nil, okCallback:@escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: "YES", style: .default, handler: { (_ ) in
            okCallback()
        })
        
        let cancel = UIAlertAction(title: "NO", style: .default, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - showLogoutAlert -
    /// Present  Logout AlertController from selected viewController with preferredStyle : `.alert` with Alert Actions Type `Cancel and Other`
    /// - Parameters:
    ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - message: Descriptive text that provides additional details about the reason for the alert.
    ///   - completion: Logout Alert completion Handler
    func showLogoutAlert(title:String = kAppTitle,message:String = "Are you sure you want to logout?", completion: (() -> Swift.Void)? = nil){
        self.showAlert(message: message) {
            completion?()
        }
        
    }
    
    func openURL(url:String) {
        if UIApplication.shared.canOpenURL(URL(string: url)!) {
            UIApplication.shared.open(URL(string: url)!)
        }
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func onMenu(_ sender:Any) {
        self.view.endEditing(true)
        if isFromMenu {
            self.navigationController?.popViewController(animated: true)
            isFromMenu = true
        } else {
            self.toggleLeft()
        }
        
    }
    func checkFileType(FileName:String)-> UIImage{
        if FileName.uppercased().hasSuffix(fileType.pdf) {
            return UIImage(named: imageFile.imgPdf)!
        } else if FileName.uppercased().hasSuffix(fileType.doc) || FileName.uppercased().hasSuffix(fileType.docs) {
            return UIImage(named: imageFile.imgdoc)!
        } else {
            return UIImage(named: imageFile.noPath)!
        }
    }
}

//MARK: Show Toast
extension UIViewController {
    
    
    
    func showToast(message : String, font: UIFont = UIFont.boldSystemFont(ofSize: 14.0)) {
        
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 0.8
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        if toastLabel.intrinsicContentSize.width > view.frame.size.width {
            toastLabel.frame = CGRect(x: self.view.frame.size.width/6, y: self.view.frame.size.height-100,width: (self.view.frame.width - 20) ,height: toastLabel.intrinsicContentSize.height + 20/*toastLabel.intrinsicContentSize.height + 20*/)
        } else {
            toastLabel.frame = CGRect(x: self.view.frame.size.width/6, y: self.view.frame.size.height-100,width: (toastLabel.intrinsicContentSize.width + 20) ,height: toastLabel.intrinsicContentSize.height + 20/*toastLabel.intrinsicContentSize.height + 20*/)

        }
        toastLabel.center = self.view.center
        toastLabel.frame.origin.y = self.view.frame.size.height-100
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(toastLabel)
        UIView.animate(withDuration: 0.8, delay: 2.2 , options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

extension UIViewController{
    
    /// storyboard Id of UIViewController
    static var storyboardID:String{
        return String(describing: self)
    }
    /// Creates the view controller with the specified UIVIewController Class Type and initializes it with the data from the storyboard.
    /// - Parameter storyboard: Custom Enum `AppStoryboard` to get Instacne object Of UIStoryboard
    /// - Returns: The view controller corresponding to the specified UIViewController Generic Type. If no view controller has the given identifier, this method throws an exception.
    static func instance(from storyboard:AppStoryboard = .Main)->Self{
        return storyboard.viewController(viewController: self)
    }
    
    /// Creates the view controller with the specified identifier and initializes it with the data from the storyboard.
    /// - Parameters:
    ///   - storyboard: Custom Enum `AppStoryboard` to get Instacne object Of UIStoryboard
    ///   - identifier: An identifier string that uniquely identifies the view controller in the storyboard file. At design time, put this same string in the Storyboard ID attribute of your view controller in Interface Builder. This identifier is not a property of the view controller object itself. The storyboard uses it to locate the appropriate data for your view controller.
    /// - Returns: The view controller corresponding to the specified identifier string. If no view controller has the given identifier, this method throws an exception.
    static func instance(from storyboard:AppStoryboard = .Main,withIdentifier identifier :StoryboardID)->Self{
        return storyboard.viewController(withIdentifier: identifier.rawValue)
    }
    
    
    //MARK: - modalPresentation
    func modalPresentation(){
        self.modalTransitionStyle(.crossDissolve)
        self.modalPresentationStyle(.overCurrentContext)
    }
    //MARK: - modalPresentation
    /// UIModalTransitionStyle = `.crossDissolve` and modalPresentationStyle = `.popover`
    func popoverPresentation(){
        self.modalTransitionStyle(.crossDissolve)
        self.modalPresentationStyle(.popover)
    }
    
    //MARK: - modalFromSheet
    /// UIModalTransitionStyle = `.crossDissolve` and modalPresentationStyle = `.formSheet`
    func modalFromSheet(){
        self.modalTransitionStyle(.crossDissolve)
        self.modalPresentationStyle(.formSheet)
    }
    /// The transition style to use when presenting the view controller.
    /// - Parameter style: Transition styles available when presenting view controllers. `  coverVertical/flipHorizontal/partialCurl`
    func modalTransitionStyle(_ style:UIModalTransitionStyle){
        self.modalTransitionStyle = style
    }
    /// The presentation style for modally presented view controllers.
    /// - Parameter style: Modal presentation styles available when presenting view controllers. `fullScreen/pageSheet/formSheet/currentContext/custom/overFullScreen/overCurrentContext/popover/none/automatic`
    func modalPresentationStyle(_ style:UIModalPresentationStyle){
        self.modalPresentationStyle = style
        
    }
}

extension UIButton
{
    //To create gradient layer on the button UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6)
    func createGradLayer(color1: UIColor = UIColor(rgb: 0x1DCDFE), color2: UIColor = UIColor(rgb: 0x34F5C6)) {
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)//.addSublayer(gradientLayer)
        
    }
    
    //To create gradient layer on the button borders
    func createGradBorder(color1: UIColor, color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors =  [color1.cgColor, color2.cgColor]
        let shape = CAShapeLayer()
        shape.lineWidth = 4
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.type = .axial
        self.clipsToBounds = true
        self.layer.addSublayer(gradient)
    }
}


extension UIColor {
    
    //For color conversion
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

public extension UIView {
    
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    
}
extension UINavigationController {

    var rootViewController: UIViewController? {
        return viewControllers.first
    }

}

class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
extension UIViewController {
//    func imagePicker1(sourceType: UIImagePickerController.SourceType)->UIImagePickerController{
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = sourceType
//        return imagePicker
//    }
//    func showImagePickerOption1(){
//        unowned(unsafe) var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
//
//        let alertVC = UIAlertController(title:fileUploadPopUp.kUploadFile,message: fileUploadPopUp.kChooseAOption, preferredStyle: .actionSheet)
//        let cameraAction = UIAlertAction(title: fileUploadPopUp.kTakeAPhoto, style: .default){
//            [weak self] (action) in
//            guard let self = self else {
//                return
//            }
//
//            let cameraImagePicker = self.imagePicker1(sourceType: .camera)
//            cameraImagePicker.delegate = delegate
//
//            self.present(cameraImagePicker, animated: true){
//        }
//    }
//    let libraryAction = UIAlertAction(title: fileUploadPopUp.kChooseFromGallery, style: .default){
//        [weak self] (action) in
//        guard let self = self else {
//            return
//        }
//
//        let libraryImagePicker = self.imagePicker1(sourceType: .photoLibrary)
//        libraryImagePicker.delegate=delegate
//        self.present(libraryImagePicker, animated: true){
//    }
//    }
//        let docuemntAction = UIAlertAction(title: fileUploadPopUp.kChooseADocument, style: .default){
//            [weak self] (action) in
//            guard let self = self else {
//                return
//            }
//            self.imgName = String("IMG_\(Date().millisecondsSince1970).png")
//
//                    let documentPicker = UIDocumentPickerViewController(documentTypes:  [String(kUTTypePDF),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)],  in: .import)
//
//                    documentPicker.delegate = self
//            self.present(documentPicker, animated: true){
//
//            }
//        }
//    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertVC.addAction(docuemntAction)
//        alertVC.addAction(cameraAction)
//        alertVC.addAction(libraryAction)
//        alertVC.addAction(cancelAction)
//        self.present(alertVC,animated: true,completion: nil)
//
//    }
    
    func imagePicker(sourceType: UIImagePickerController.SourceType)->UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    //Method to Show Image Picker Option
    func showImagePickerOption(delegate : (UIImagePickerControllerDelegate & UINavigationControllerDelegate & UIDocumentPickerDelegate)?){
        //unowned(unsafe) var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate & UIDocumentPickerDelegate)?

        let alertVC = UIAlertController(title:fileUploadPopUp.kUploadFile,message: fileUploadPopUp.kChooseAOption, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: fileUploadPopUp.kTakeAPhoto, style: .default){
            [weak self] (action) in
            guard let self = self else {
                return
            }

            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = delegate

            self.present(cameraImagePicker, animated: true){
        }
    }
    let libraryAction = UIAlertAction(title: fileUploadPopUp.kChooseFromGallery, style: .default){
        [weak self] (action) in
        guard let self = self else {
            return
        }

        let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
        libraryImagePicker.delegate=delegate
        self.present(libraryImagePicker, animated: true){
    }
    }
        let docuemntAction = UIAlertAction(title: fileUploadPopUp.kChooseADocument, style: .default){
            [weak self] (action) in
            guard let self = self else {
                return
            }

                    let documentPicker = UIDocumentPickerViewController(documentTypes:  [String(kUTTypePDF),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)],  in: .import)
            
                    documentPicker.delegate = delegate
            self.present(documentPicker, animated: true){
                
            }
        }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(docuemntAction)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC,animated: true,completion: nil)
    }

}
