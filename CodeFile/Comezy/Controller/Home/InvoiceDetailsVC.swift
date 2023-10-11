//
//  InvoiceDetailsVC.swift
//  Comezy
//
//  Created by Lalit Kumar on 07/06/23.
//

import UIKit

class InvoiceItemsTblCell: UITableViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
}

class InvoiceDetailsVC: UIViewController {
    
    @IBOutlet weak var lblCreatedDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblBillingFrom: UILabel!
    @IBOutlet weak var lblBillingTo: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblBillingToAddress: UILabel!
    @IBOutlet weak var lblBillingFromAddress: UILabel!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnMarkAsPaid: UIButton!
    @IBOutlet weak var btnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var btnEditWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnEditLeadingConstraint: NSLayoutConstraint!
    
    var isFrom = false
    
    
    
    var invoiceId = 0
    var scheduleVM = InvoiceDetailsViewModel()
    var shareLink = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scheduleVM.getInvoiceDetails(invoiceId: self.invoiceId) {
            let invoiceData = self.scheduleVM.jsonData?.data?.invoice
            self.lblCustomerName.text = self.scheduleVM.jsonData?.data?.invoice?.client ?? ""
            self.lblNote.text = self.scheduleVM.jsonData?.data?.invoice?.note ?? ""
            let dateValue = self.scheduleVM.jsonData?.data?.invoice?.created_date?.components(separatedBy: "T")
            self.lblCreatedDate.text = dateValue?[0]
            self.lblTerms.text = invoiceData?.terms ?? ""
            self.lblTax.text = "\(invoiceData?.tax_amount ?? 0.0)"
            self.lblSubTotal.text = "\(invoiceData?.sub_total ?? 0)"
            self.lblTotal.text = "\(invoiceData?.total_amount ?? 0.0)"
            self.lblBillingTo.text = invoiceData?.client
            self.lblBillingToAddress.text = invoiceData?.address?.name ?? ""
            self.shareLink = self.scheduleVM.jsonData?.data?.invoice?.pdf_link ?? ""
            self.viewHeightConstraint.constant = CGFloat(((invoiceData?.items?.count ?? 0) + 1) * 45)
            self.tableView.reloadData()
            
            self.btnMarkAsPaid.isHidden = true
            self.btnTopConstraint.constant = 0
            self.btnBottomConstraint.constant = 0
            self.btnHeightConstraint.constant = 0
            self.btnEdit.isHidden = true
            
            if self.isFrom {
                self.btnMarkAsPaid.isHidden = true
                self.btnTopConstraint.constant = 0
                self.btnBottomConstraint.constant = 0
                self.btnHeightConstraint.constant = 0
                self.btnEdit.isHidden = true
            } else {
                if invoiceData?.status ?? false {
                    self.btnMarkAsPaid.isHidden = true
                    self.btnTopConstraint.constant = 0
                    self.btnBottomConstraint.constant = 0
                    self.btnHeightConstraint.constant = 0
                    self.btnEdit.isHidden = true
                    self.btnEditWidthConstraint.constant = 0
                    self.btnEditLeadingConstraint.constant = 0
                } else {
                    self.btnMarkAsPaid.isHidden = false
                    self.btnTopConstraint.constant = 16
                    self.btnBottomConstraint.constant = 24
                    self.btnHeightConstraint.constant = 40
                    self.btnEdit.isHidden = false
                    self.btnEditWidthConstraint.constant = 22
                    self.btnEditLeadingConstraint.constant = 16
                }
            }
            
            
        }
        
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func btnMarkAsPaidClicked(_ sender: UIButton) {
        self.scheduleVM.changeInvoiceStatus(invoiceId: self.invoiceId, status: true) {
            Alerts.shared.alertMessageWithActionOk(title: "Success", message: "Invoice Marked as paid") {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditInvoiceVC") as! EditInvoiceVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnShareClicked(_ sender: UIButton) {
        
        
       // guard let data = URL(string: self.shareLink) else { return }
        if let data = URL(string: self.shareLink) {
            let av = UIActivityViewController(activityItems: ["Hello \(self.lblCustomerName.text ?? ""), Please visit below link to download it. Thanks!",data], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        } else {
            print("no url")
        }
       
    }
    
    

}


//MARK: - TABLE VIEW
extension InvoiceDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceItemsTblCell", for: indexPath) as! InvoiceItemsTblCell
        let dict = self.scheduleVM.jsonData?.data?.invoice?.items?[indexPath.row]
        cell.lblDesc.text = dict?.name
        cell.lblPrice.text = "\(dict?.price ?? 0) "
        cell.lblQuantity.text = "\(dict?.quantity ?? 0)"
        cell.lblTotalPrice.text = "\(dict?.total_price ?? 0)"
        cell.viewMain.backgroundColor = UIColor.white

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.scheduleVM.jsonData?.data?.invoice?.items?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}
