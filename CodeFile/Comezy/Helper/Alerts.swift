//
//  Alerts.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import UIKit

class Alerts {
    
    //MARK: - SINGLTON CLASS INSTANCE
    static var shared: Alerts {
        return Alerts()
    }
 
    fileprivate init(){}
    
    //MARK: - SHOW ALERT ACTION WITH NO COMPLITION
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        let getController = AppInitializers.shared.getCurrentViewController()
        DispatchQueue.main.async {
            if let _ = getController.presentingViewController {
                currentCont.present(alert, animated: true, completion: nil)
            } else {
                UIWindow.key.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - SHOW ALERT ACTION WITH OKAY AND CANCEL ACTION
    func alertMessageWithActionOkCancel(title: String, message: String,action:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: Constantss.AlertButtonsTitle.okay, style: .default) {  (result : UIAlertAction) -> Void in
            action()
        }
        let cancel = UIAlertAction(title: Constantss.AlertButtonsTitle.cancel, style: .default) {  (result : UIAlertAction) -> Void in
            UIWindow.key.rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(cancel)
        let getController = AppInitializers.shared.getCurrentViewController()
        DispatchQueue.main.async {
            if let _ = getController.presentingViewController {
                currentCont.present(alert, animated: true, completion: nil)
            } else {
                UIWindow.key.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - SHOW ALERT ACTION WITH OKAY ACTION
    func alertMessageWithActionOk(title: String, message: String,action:@escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: Constantss.AlertButtonsTitle.okay, style: .default) {  (result : UIAlertAction) -> Void in
            action()
        }
        alert.addAction(action)
        let getController = AppInitializers.shared.getCurrentViewController()
        DispatchQueue.main.async {
            if let _ = getController.presentingViewController {
                currentCont.present(alert, animated: true, completion: nil)
            } else {
                UIWindow.key.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - OPEN SETTING OF THE APP
    func openSettingApp() {
        let settingAlert = UIAlertController(title: Constantss.ValidationMessages.connectionProblem, message: Constantss.AlertMessages.checkInternet, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: Constantss.AlertButtonsTitle.cancel, style: UIAlertAction.Style.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title: Constantss.AlertButtonsTitle.setting, style:UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Alerts.shared.showAlert(title: AppInfo.alert, message: Constantss.AlertMessages.pleaseReviewyournetworksettings)
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        let currentController = UIWindow.key.rootViewController
        DispatchQueue.main.async {
            if let _ = currentController?.presentingViewController {
                currentCont.present(settingAlert, animated: true, completion: nil)
            } else {
                UIWindow.key.rootViewController?.present(settingAlert, animated: true, completion: nil)
            }
        }
    }
}
