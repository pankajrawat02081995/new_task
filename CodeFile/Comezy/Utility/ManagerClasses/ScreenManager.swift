//
//  ScreenManager.swift
//  InsuranceCalculator
//
//  Created by MAC on 29/04/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import UIKit

class ScreenManager {
    private init() {}
    
    enum Storyboard : String {
        case main = "Main"
        case editVariation = "EditVariations"
        case general = "General"
        case safety = "Safety"
        case projectStatus = "ProjectStatus"
        case schedule = "Schedule"
    }
    
    class  func getRootViewController() -> UIViewController {
        if kUserData == nil {
        let controller = getController(storyboard: .main, controller: LandingVC())
        return getColoredNavigationController(controller)
        } else {
            guard let mainViewController =  DKLeftMenu.notifications.navigationController else{return UIViewController()}
            let rightMenuViewController = UINavigationController.instance(from: .Main, withIdentifier: .kRightSlideNavigationController)
//            let slideMenuController = JKSlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController, enableRightPanGesture: false, enableRightTapGesture: true)
            let slideMenuController = JKSlideMenuController(mainViewController: mainViewController, leftMenuViewController: rightMenuViewController, enableLeftPanGeture: false, enableLeftTapGeture: true)
            //let controller = getController(storyboard: .main, controller: HomeVC())
            return slideMenuController
        }
    }
    
    class  func getRootViewControllerForEmail() -> UIViewController {
        if kUserData != nil {
        let controller = getController(storyboard: .main, controller: LandingVC())
        return getColoredNavigationController(controller)
        } else {
            guard let mainViewController =  DKLeftMenu.notifications.navigationController else{return UIViewController()}
            let rightMenuViewController = UINavigationController.instance(from: .Main, withIdentifier: .kRightSlideNavigationController)
//            let slideMenuController = JKSlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightMenuViewController, enableRightPanGesture: false, enableRightTapGesture: true)
            let slideMenuController = JKSlideMenuController(mainViewController: mainViewController, leftMenuViewController: rightMenuViewController, enableLeftPanGeture: false, enableLeftTapGeture: true)
            
            //let controller = getController(storyboard: .main, controller: HomeVC())
            return slideMenuController
        }
    }
    
    class func setAsMainViewController(_ viewController: UIViewController) {
        if viewController.isKind(of: UITabBarController.self) {
            UIApplication.shared.keyWindow?.rootViewController = viewController
        } else {
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
    
    class func getCurrentViewController() -> UIViewController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if let controller = navigationController.viewControllers.last {
                return controller
             }
        }
        return nil
    }

    
    class func getTransparentNavigationController(_ viewController:UIViewController?=nil) -> UINavigationController {
        let navigationController = UINavigationController(navigationBarClass: TransparentNavigationBar.self, toolbarClass: UIToolbar.self)
        if let controller = viewController {
            navigationController.viewControllers = [controller]
        }
        return navigationController
    }
    
    class func getColoredNavigationController(_ viewController:UIViewController?=nil) -> UINavigationController {
        let navigationController = UINavigationController(navigationBarClass: ColoredNavigationBar.self, toolbarClass: UIToolbar.self)
        if let controller = viewController {
            navigationController.viewControllers = [controller]
        }
        return navigationController
    }
    
    class func getController(storyboard:Storyboard,controller:UIViewController) -> UIViewController {
        let storyBoard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: String(describing: controller.classForCoder))
    }
}

var currentController:UIViewController?{
    
    if let navController  =  rootController as? UINavigationController {
        if  let visibleViewController = navController.visibleViewController {
            return visibleViewController
        } else {
            return navController
        }
    } else if let sideController  =  rootController as? JKSlideMenuController, let navController = sideController.mainViewController as? UINavigationController {
        if  let visibleViewController = navController.visibleViewController {
            return visibleViewController
        } else {
            return sideController
        }
    } else if let tabBarController  =  rootController as? UITabBarController, let navController = tabBarController.selectedViewController as? UINavigationController{
        if  let visibleViewController = navController.visibleViewController{
            return visibleViewController
        }else{
            return tabBarController
        }
    } 
    return nil
}

var rootController:UIViewController?{
    return UIApplication.shared.windows[0].rootViewController //AppDelegate.sharedDelegate.window?.rootViewController
}
