//
//  AccountingVC.swift
//  Comezy
//
//  Created by Lalit Kumar on 01/06/23.
//

import UIKit

class AccountingTblCell: UITableViewCell {
    
    @IBOutlet weak var imgRow: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
}

class AccountingVC: UIViewController {
    
    var arrImages = [UIImage.init(named: "ic_receipt-item"), UIImage.init(named: "ic_note"), UIImage.init(named: "ic_dollar-circle")]
    var arrNames = ["Invoice", "Purchase Order", "Profit & Loss"]
    
    var projectId : Int?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}


//MARK: - TABLE VIEW
extension AccountingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountingTblCell", for: indexPath) as! AccountingTblCell
        cell.lblName.text = self.arrNames[indexPath.row]
        cell.imgRow.image = self.arrImages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = ScreenManager.getController(storyboard: .main, controller: InvoiceListsVC()) as! InvoiceListsVC
            vc.projectId = self.projectId
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1{
            
        } else {
            let vc = ScreenManager.getController(storyboard: .main, controller: P_LSummary()) as! P_LSummary
            vc.projectId = self.projectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
