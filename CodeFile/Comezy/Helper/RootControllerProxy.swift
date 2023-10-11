//
//  RootControllerProxy.swift
//  Picker
//
//  Created by Developer IOS on 29/05/23.
//

import UIKit

class RootControllerProxy {
    
    //MARK: - DECLEARE THE SHARED INSTANCE
    static var shared: RootControllerProxy {
        return RootControllerProxy()
    }
    
    fileprivate init(){}
    
    // MARK: - SET Root Without Drawer Method
    func rootWithoutDrawer(_ identifier: String,storyboard: Storyboards) {
        let blankController = getStoryboard(storyboard).instantiateViewController(withIdentifier: identifier)
        var homeNavController:UINavigationController = UINavigationController()
        homeNavController = UINavigationController.init(rootViewController: blankController)
        homeNavController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = homeNavController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
