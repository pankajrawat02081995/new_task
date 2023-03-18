//
//  APIClient.swift
//  Comezy
//
//  Created by shiphul on 03/12/21.
//

import Foundation
import UIKit

class APIClient{
    func getData()->[Item]{
        var array:[Item]=[Item]()
        
        let item1 = Item(image:UIImage.init(named: "difference"), text:"VARIATIONS")
        let item2 = Item(image:UIImage.init(named: "info-outline"), text:"SPECIFICATIONS & PRODUCT INFORMATION")
        let item3 = Item(image:UIImage.init(named: "bx-check-shield"), text:"SAFETY")
        let item4 = Item(image:UIImage.init(named: "upload"), text:"GENERAL")
    
        array.append(item1)
        array.append(item2)
        array.append(item3)
        array.append(item4)
        
        return array
    }
    
    func getSafetyData() -> [Item] {
        var array:[Item]=[Item]()

        let item1 = Item(image:UIImage.init(named: "difference"), text:"SAFETY WORK METHOD STATEMENT")
        let item2 = Item(image:UIImage.init(named: "info-outline"), text:"MATERIAL SAFETY DATA SHEETS")
        let item3 = Item(image:UIImage.init(named: "bx-check-shield"), text:"SITE SAFETY ASSESSMENT")
        let item4 = Item(image:UIImage.init(named: "upload"), text:"INCIDENT REPORT")
        let item5 = Item(image:UIImage.init(named: "upload"), text:"WORK HEALTH & SAFETY PLAN")

    
        array.append(item1)
        array.append(item2)
        array.append(item3)
        array.append(item4)
        array.append(item5)
        
        return array
    }
    
}

