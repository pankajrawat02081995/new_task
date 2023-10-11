//
//  Error+Ex.swift
//  ChatterBox
//
//  Created by Jitendra Kumar on 29/05/20.
//  Copyright © 2020 Jitendra Kumar. All rights reserved.
//

import Foundation
extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    
}
