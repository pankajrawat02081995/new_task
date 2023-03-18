//
//  DailyItemApiClient.swift
//  Comezy
//
//  Created by shiphul on 22/12/21.
//

import Foundation
import UIKit

class DailyItemApiClient{
    func getData1()->[DailysItem]{
        var array:[DailysItem]=[DailysItem]()
        if((kUserData?.user_type != UserType.kClient) == true){
            let item1 = DailysItem(image:UIImage.init(named: "file-check"), text:"TASKS")
            let item2 = DailysItem(image:UIImage.init(named: "file-text"), text:"TIMESHEETS")
            let item3 = DailysItem(image:UIImage.init(named: "event-schedule"), text:"SCHEDULE")
            let item4 = DailysItem(image:UIImage.init(named: "file-group-line"), text:"DAILY WORK REPORT")
            array.append(item1)
            array.append(item2)
            array.append(item3)
            array.append(item4)
        }else{
            let item3 = DailysItem(image:UIImage.init(named: "event-schedule"), text:"SCHEDULE")
            let item4 = DailysItem(image:UIImage.init(named: "file-group-line"), text:"DAILY WORK REPORT")
            array.append(item3)
            array.append(item4)
        }
    
        
        
        return array
    }
}
