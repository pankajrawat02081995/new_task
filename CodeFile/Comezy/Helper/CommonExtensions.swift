//
//  CommonExtensions.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import UIKit
import SDWebImage

extension UIWindow {
    static var key: UIWindow! {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension JSONDecoder {
    func decode<T : Decodable> (model: T.Type, data: Data) -> T? {
        let myStruct = try! self.decode(model, from: data)
        return myStruct
    }
}
extension UserDefaults {
    
    func setData<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func valueData<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}

extension UIImageView {
    
    func setImageOnImageView(_ urlStr: String,placeholder: UIImage) {
        debugPrint("Profile Url:- ","\(ServerLink.imageBaseUrl)\(urlStr)")
        self.sd_setImage(with: URL(string: "\(ServerLink.imageBaseUrl)\(urlStr)"), placeholderImage: placeholder, options: .highPriority, completed: nil)
    }
    
    func setImageOnImageViewWithoutServer(_ urlStr: String,placeholder: UIImage) {
        self.sd_setImage(with: URL(string: urlStr), placeholderImage: placeholder, options: .highPriority, completed: nil)
    }
}


extension UIViewController{
    
    // MARK: - Create Action Sheet
    
    func presentActionSheet(options:[String], completion: @escaping(String) -> ()) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for i in options{
            if i == "Cancel" {
                let action = UIAlertAction(title: i, style: .cancel) { (action) in
                    completion(i)
                }
                //action.setValue(UIColor.red, forKey: "titleTextColor")
                actionSheet.addAction(action)
            } else if i == "Delete"{
                let action = UIAlertAction(title: i, style: .default) { (action) in
                    completion(i)
                }
                action.setValue(UIColor.red, forKey: "titleTextColor")
                actionSheet.addAction(action)
            } else {
                let action = UIAlertAction(title: i, style: .default) { (action) in
                    completion(i)
                }
                actionSheet.addAction(action)
            }
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
}
