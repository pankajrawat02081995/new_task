//
//  ImagePicker.swift
//  HeadzApp
//
//  Created by Sunil Garg on 26/11/19.
//  Copyright © 2019 harishkumar. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func checkPhotoLibraryPermission(sourceView: UIView)-> Bool {
        
        var isEnabled = false
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    isEnabled = true
                    print("access granted")
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        
                        if let action = self.action(for: .camera, title: "Take photo") {
                            alertController.addAction(action)
                        }
                        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
                            alertController.addAction(action)
                        }
                        if let action = self.action(for: .photoLibrary, title: "Photo library") {
                            alertController.addAction(action)
                        }
                        
                        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            alertController.popoverPresentationController?.sourceView = sourceView
                            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
                            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
                        }
                        
                        self.presentationController?.present(alertController, animated: true)
                    }
                    
                }
                else {
                    
                    isEnabled = false
                    print("access denied")
                
                }
            }
            
        case .authorized:
            isEnabled = true
            print("Access authorized")
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                if let action = self.action(for: .camera, title: "Take photo") {
                    alertController.addAction(action)
                }
                if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
                    alertController.addAction(action)
                }
                if let action = self.action(for: .photoLibrary, title: "Photo library") {
                    alertController.addAction(action)
                }
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    alertController.popoverPresentationController?.sourceView = sourceView
                    alertController.popoverPresentationController?.sourceRect = sourceView.bounds
                    alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
                }
                
                self.presentationController?.present(alertController, animated: true)
            }
            
            
        case .denied, .restricted:
            isEnabled = false
            print("restricted")
            self.cameraAlert(message: "Please allow camera to take pictures, you can go to device settings and manually grant permission")
        }
        
        return isEnabled
        
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        if checkPhotoLibraryPermission(sourceView: sourceView) == true{
            
        }
        else{
            
        }
        
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
    
    func cameraAlert(message:String){

           if let controller  =  currentController {
            let alertController = UIAlertController(title: App.name, message: message ?? "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            let action2 = UIAlertAction(title: "Settings", style: .default){ _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else{return}
                if #available(iOS 10, *) {
                    let open = UIApplication.shared.canOpenURL(url)
                    if  open {

                         UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }

                }else{
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(action)
            alertController.addAction(action2)
            controller.present(alertController, animated: true, completion: nil)
           }

       }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
