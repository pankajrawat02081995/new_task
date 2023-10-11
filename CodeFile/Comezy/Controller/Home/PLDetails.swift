//
//  PLDetails.swift
//  Comezy
//
//  Created by Lalit Kumar on 28/09/23.
//

import UIKit


class PurchaseCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
}

class PLDetails: UIViewController {

    
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblBillingTo: UILabel!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblAddressName: UILabel!
    @IBOutlet weak var lblInvoiceDate: UILabel!
    @IBOutlet weak var lblInvoiceNumber: UILabel!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblTotalEarning: UILabel!
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var lblDatePurchaseItems: UILabel!
    
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    
    var objProfitLostVM = PLDetailsViewModel()
    var jsonData = [PLDetailsPurchase]()
    var projectId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.objProfitLostVM.getProfitLostList(projectId: self.projectId) {
            let dict = self.objProfitLostVM.jsonData?.data
           self.lblCustomerName.text = "\(dict?.client?.first_name ?? "") \(dict?.client?.last_name ?? "")"
            self.lblBillingTo.text = "\(dict?.client?.first_name ?? "") \(dict?.client?.last_name ?? "")"
            let name = UserDefaults.standard.value(forKey: "PROJECT_NAME") as? String
            self.lblProjectName.text = name
            self.lblAddressName.text = dict?.address?.name ?? ""
            self.jsonData = dict?.purchase ?? []
            self.tableView.reloadData()
            self.lblExpense.text = "\(dict?.purchase_payment_amount ?? 0)"
            self.lblTotalEarning.text = "\(dict?.amount_of_invoice ?? 0)"
            let purchaseDate = dict?.purchase?[0].purchase?.created_date?.components(separatedBy: "T")
            self.lblDatePurchaseItems.text = purchaseDate?[0]
            
            
            self.viewHeightConstraint.constant = CGFloat(((self.objProfitLostVM.jsonData?.data?.purchase?[0].item?.count ?? 0 ) * 50) + 60)
            
            let dateValue = dict?.invoice_list?[0].invoice?.created_date?.components(separatedBy: "T")
            self.lblInvoiceDate.text = dateValue?[0]
            self.lblInvoiceNumber.text = "\(dict?.invoice_list?[0].invoice?.invoice_code ?? "")   \(dict?.invoice_list?[0].invoice?.amount_of_invoice ?? 0)"
            
            self.lblTotalAmount.text = "\(dict?.total_profit_loss ?? 0 )"
            
        }
        
    }
    
    
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}


//MARK: - TABLE VIEW
extension PLDetails: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objProfitLostVM.jsonData?.data?.purchase?[0].item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell", for: indexPath) as! PurchaseCell
        let dict = self.objProfitLostVM.jsonData?.data?.purchase?[0].item?[indexPath.row]
        cell.lblDescription.text = dict?.name ?? ""
        cell.lblPrice.text = "\(dict?.price ?? 0)"
        cell.lblQuantity.text = "\(dict?.quantity ?? 0)"
        cell.lblTotalPrice.text = "\((dict?.price ?? 0)*(dict?.quantity ?? 0))"
        return cell
    }
    
    
}
