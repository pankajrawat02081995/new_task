//
//  SiteRiskTblCell.swift
//  Comezy
//
//  Created by aakarshit on 05/07/22.
//

import UIKit

class SiteRiskTblCell: UITableViewCell {
    //Variables
    var callback: (()->Void)?
    var callbackproof: (()->Void)?

    //IB Outlet of View
    @IBOutlet weak var lblSiteRiskQuestion: UILabel!
    @IBOutlet weak var lblLabelAssignedTo: UILabel!
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var lblAssignedTo: UILabel!
    @IBOutlet weak var lblResponse: UILabel!
    @IBOutlet weak var lblFile: UILabel!
    @IBOutlet weak var lblWorkerResponse: UILabel!
    @IBOutlet weak var workerResponse: UILabel!
    @IBOutlet weak var lblProofFile: UILabel!
    @IBOutlet weak var proofFile: UIImageView!
    @IBOutlet weak var workerProofStack: UIStackView!
    @IBOutlet weak var workerResponseStack: UIStackView!
    @IBOutlet weak var builderResponseStack: UIStackView!
    @IBOutlet weak var assignedToStack: UIStackView!
    @IBOutlet weak var proofImageFileConstaint: NSLayoutConstraint!
    
    ///Cell LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization coqde
        gestureInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            }
    
    ///Gesture initialization
    func gestureInit() {
        let onFileImageTap = UITapGestureRecognizer(target: self, action: #selector(fileImageTapped(_:)))
        fileImageView.isUserInteractionEnabled = true
        fileImageView.addGestureRecognizer(onFileImageTap)
        let onProofFileTap = UITapGestureRecognizer(target: self, action: #selector(imageProofFileTapped(_:)))
        proofFile.isUserInteractionEnabled = true
        proofFile.addGestureRecognizer(onProofFileTap)

    }
    
    ///Method to hide file
    func noFile() {
        lblFile.isHidden = true
        fileImageView.isHidden = true
    }

    ///Method to show file
    func yesFile() {
        lblFile.isHidden = false
        fileImageView.isHidden = false
    }
   
    ///Method to image Tapped
    @objc func fileImageTapped(_ sender: UITapGestureRecognizer? = nil) {
        callback?()
    }
    
    ///Method to proof file tapped
    @objc func imageProofFileTapped(_ sender: UITapGestureRecognizer? = nil) {
        callbackproof?()
    }
}
