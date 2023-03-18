//
//  AppEnums.swift
//  Comezy
//
//  Created by mandeepkaur on 13/07/21.
//

import UIKit

enum AppStoryboard:String {
    case Main
    
    
    var instance:UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    /// Creates the view controller with the specified UIVIewController Class Type and initializes it with the data from the storyboard.
    /// - Parameter classObject: UIVIewController Class Object For Get `StoryboardID`
    /// - Returns: The view controller corresponding to the specified `UIViewController` Generic Type. If no view controller has the given identifier, this method throws an exception.
    func viewController<T:UIViewController>(viewController classObject :T.Type)->T{
        let storyboardId = classObject.storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    /// Creates the view controller with the specified identifier and initializes it with the data from the storyboard.
    /// - Parameter identifier: An identifier string that uniquely identifies the view controller in the storyboard file. At design time, put this same string in the Storyboard ID attribute of your view controller in Interface Builder. This identifier is not a property of the view controller object itself. The storyboard uses it to locate the appropriate data for your view controller.
    ///
    ///-  If the specified identifier does not exist in the storyboard file, this method raises an exception.
    /// - Returns: The view controller corresponding to the specified identifier string. If no view controller has the given identifier, this method throws an exception.
    func viewController<T:UIViewController>(withIdentifier identifier :String)->T{
        return instance.instantiateViewController(withIdentifier: identifier) as! T
    }
    /// Creates the initial view controller and initializes it with the data from the
    /// - Returns: The initial view controller in the storyboard.
    func initalViewController<T:UIViewController>()->T?{
        return instance.instantiateInitialViewController() as? T
    }
}

var kAppTitle :String           {get{return Bundle.kAppTitle}}
let kUserDataKey            = "ComezyUserData"
let kAuthTokenKey           = "ComezyAuthToken"


var isFromMenu:Bool{
    set{ UserDefaults.set(archivedObject: newValue, forKey: "isFromMenu")
    }
    get{
        //UserDefaults[boolKey: "isFromMenu"]
        UserDefaults.getBool(forKey: "isFromMenu")
    }
}
