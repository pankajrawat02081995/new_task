//
//  AddSiteRiskCell.swift
//  Comezy
//
//  Created by aakarshit on 06/07/22.
//

import UIKit
import MBProgressHUD
import MobileCoreServices


class AddSiteRiskCell: UITableViewCell {
    //MARK: - Variable
    ///Variables
    var arrayOfAddedVariations = [String]()
    var arrayOfAddedVariationsURL = [String]()
    var arrayPath : URL?
    var callback: (()->Void)?
    var rejectCallback: (()->Void)?
    var acceptCallback: (()->Void)?
    var viewRef: AddSiteRiskVC?
    var ProjectId: Int?
    var personSelectedCallBack: ((Int)->Void)?
    var currentCellIndex: Int?
    
///IB Outlet of storyboard view
    @IBOutlet weak var lblFileHeight: NSLayoutConstraint!
    @IBOutlet weak var builderResponse: UILabel!
    @IBOutlet weak var selectPersonStackHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lbFile: UILabel!
    @IBOutlet weak var btnAddFileHeight: NSLayoutConstraint!
    @IBOutlet weak var builderResponseStack: UIStackView!
    @IBOutlet weak var selectPersonStack: UIStackView!
    @IBOutlet weak var txtAssign: UITextField!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnAddFile: UIButton!
    
    //MARK: - View controller Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Add grid layer on accept butotn
        btnAccept.createGradLayer()
        
        //UITap gesture on select person text
        txtAssign.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(personSelected(_:)))
        selectPersonStack.addGestureRecognizer(tap)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - IB action of view controllers button
    @IBAction func btnAddFile_action(_ sender: Any) {
        print("buttonPressed")
        callback?()
    }
    
    @IBAction func btnRejectResponse(_ sender: Any) {
        rejectCallback?()

    }
    
    @IBAction func btnAcceptResponse(_ sender: Any) {
        acceptCallback?()

    }
    //MARK: - Other Methods
    @objc func personSelected(_ sender: UITapGestureRecognizer? = nil) {
        txtAssign.inputView = UIView.init(frame: CGRect.zero)
        txtAssign.inputAccessoryView = UIView.init(frame: CGRect.zero)
        viewRef?.showAllPeople(cellIndex: currentCellIndex ?? 0, txtAssign: txtAssign)
    }
}
