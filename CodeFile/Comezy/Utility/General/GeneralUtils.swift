//
//  GeneralUtils.swift
//  Comezy
//
//  Created by prince on 18/01/23.
//

import Foundation
import UIKit

func checkFileType(FileName:String)-> UIImage{
    if FileName.uppercased().hasSuffix("PDF") {
        return UIImage(named: "ic_pdf")!
    } else if FileName.uppercased().hasSuffix("DOC") || FileName.uppercased().hasSuffix("DOCX") {
        return UIImage(named: "ic_doc")!
    } else {
        return UIImage(named: "NoPath - Copy (19)")!
    }
}
