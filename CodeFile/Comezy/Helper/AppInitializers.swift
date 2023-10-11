//
//  AppInitializers.swift
//  X-Vault
//
//  Created by netset on 09/12/22.
//

import UIKit
import IQKeyboardManagerSwift

final class AppInitializers {
    
    static var shared: AppInitializers {
        return AppInitializers()
    }
    
    private init() {}
    
    func setupAppThings() {
        RootControllerProxy.shared.rootWithoutDrawer(accessTokenSaved != "" ? ViewControllers.tabbarVC  : ViewControllers.loginVC, storyboard: accessTokenSaved != "" ? .home : .loginSignUpFlow)
        setupKeyboard()
    }
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = false
    }
    
    func getCurrentViewController() -> UIViewController {
        let newVC = UIViewController()
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            return findTopViewController(viewController: viewController)
        }
        return newVC
    }
    
    func findTopViewController(viewController : UIViewController) -> UIViewController {
        if viewController is UITabBarController {
            let controller = viewController as! UITabBarController
            return findTopViewController(viewController: controller.selectedViewController!)
        } else if viewController is UINavigationController {
            let controller = viewController as! UINavigationController
            return findTopViewController(viewController: controller.visibleViewController!)
        }
        return viewController
    }
}

