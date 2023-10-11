//
//  UITextField+SecureToggle.swift
//  Comezy
//
//  Created by aakarshit on 03/05/22.
//

import Foundation
import UIKit
import SwiftUI

//let button = UIButton(type: .custom)

//extension UITextField {
    
//    func enablePasswordToggle() {
//            isSecureTextEntry = true
//            button.isSelected = false
//        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
//        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
//        rightView = button
//        rightViewMode = .always
//        button.alpha = 1.0
//        button.tintColor = .white
//    }
//
//    @objc func togglePasswordView(_ sender: Any) {
//        isSecureTextEntry.toggle()
//        button.isSelected.toggle()
//    }
//}

private var maxLengths = [UITextField: Int]()

extension UITextField {
    
    
    //MARK:- Maximum length
       @IBInspectable var maxLength: Int {
           get {
               guard let length = maxLengths[self] else {
                   return 100
               }
               return length
           }
           set {
               maxLengths[self] = newValue
               addTarget(self, action: #selector(fixMax), for: .editingChanged)
           }
       }
       @objc func fixMax(textField: UITextField) {
           let text = textField.text
           textField.text = text?.safelyLimitedTo(length: maxLength)
       }
    
    /* addBottomLine should only be used in signUpVC because of the size*/
    func addBottomLine(vC: UIViewController) {
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: vC.view.frame.width - 40, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
        
    }
    
    func addBottomLineFieldWidth() {
        var bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width - 40, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    
}
