//
//  P&LSummary.swift
//  Comezy
//
//  Created by Lalit Kumar on 11/07/23.
//

import UIKit

class PurchaseOrderTblCell: UITableViewCell {
    
    @IBOutlet weak var lblInvoiceNumber: UILabel!
    
    
    @IBOutlet weak var lblClientName: UILabel!
    
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
}


class InvoiceListCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblInvoiceNumberAndAmount: UILabel!
    
}

class P_LSummary: UIViewController {
    
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var viewPLSummary: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var lblTotalEarning: UILabel!
    @IBOutlet weak var lblPL: UILabel!
    
    
    var currentIndex = 0
    var projectId : Int?
    var plViewModel = P_LViewModel()
    var invoiceList = [InvoicesList]()
    var purcahseList = [PurchaseListData]()
    var startDate: String?
    var endDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let name = UserDefaults.standard.value(forKey: "PROJECT_NAME") as? String
        self.lblProjectName.text = name
        self.currentIndex = 0
        
        self.viewPLSummary.isHidden = true
        
        plViewModel.getInvoicesList(projectId: self.projectId ?? 0, startDate: "", endDate: "") {
            let invoiceData = self.plViewModel.jsonData?.data?.results?.invoices
            if invoiceData?.count ?? 0 > 0 {
                self.tableView.isHidden = false
                self.lblNoData.isHidden = true
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
                self.lblNoData.isHidden = false
            }
            
        }
        
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.viewPLSummary.isHidden = true
            plViewModel.getInvoicesList(projectId: self.projectId ?? 0, startDate: "", endDate: "") {
                let invoiceData = self.plViewModel.jsonData?.data?.results?.invoices
                if invoiceData?.count ?? 0 > 0 {
                    self.tableView.isHidden = false
                    self.lblNoData.isHidden = true
                    self.tableView.reloadData()
                } else {
                    self.tableView.isHidden = true
                    self.lblNoData.isHidden = false
                }
                
            }
            self.currentIndex = 0
        } else if sender.selectedSegmentIndex == 1 {
            self.currentIndex = 1
            self.viewPLSummary.isHidden = true
            self.plViewModel.getPurchaseOrdersList(projectId: self.projectId ?? 0) {
                let purchaseList = self.plViewModel.purchaseData?.data?.results?.purchase_details
                if purchaseList?.count ?? 0 > 0 {
                    self.tableView.isHidden = false
                    self.lblNoData.isHidden = true
                    self.tableView.reloadData()
                } else {
                    self.tableView.isHidden = true
                    self.lblNoData.isHidden = false
                }
            }
        } else {
            self.currentIndex = 2
            self.tableView.isHidden = true
            plViewModel.getProfitLostList(projectId: self.projectId ?? 0) {
                let plData = self.plViewModel.profitLostData?.data
                self.viewPLSummary.isHidden = false
                self.tableView.isHidden = true
                self.lblName.text = "\(plData?.client?.first_name ?? "") \(plData?.client?.last_name ?? "")"
                let currency = plData?.currency ?? ""
                self.lblTotalEarning.text = "\(currency) \(plData?.total_earning ?? 0)"
                self.lblExpense.text = "\(currency) \(plData?.expenses ?? 0)"
                self.lblPL.text = "\(currency) \(plData?.total_profit_loss ?? 0)"
                self.lblNoData.isHidden = true
            }
        }
    }
    
    
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PLFilterVC") as! PLFilterVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.startDate = self.startDate ?? ""
        vc.endDate = self.endDate ?? ""
        self.present(vc, animated: true)
    }
    
    
    
    
    @IBAction func btnPLDetailsClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PLDetails") as! PLDetails
        vc.projectId = self.projectId ?? 0
        self.navigationController?.pushViewController(vc, animated: true)        
    }
    
    
    
}


//MARK: - TABLE VIEW
extension P_LSummary: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentIndex == 0 {
            return self.plViewModel.jsonData?.data?.results?.invoices?.count ?? 0
        }  else if currentIndex == 1{
            return self.plViewModel.purchaseData?.data?.results?.purchase_details?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceListCell", for: indexPath) as! InvoiceListCell
            let dict = self.plViewModel.jsonData?.data?.results?.invoices?[indexPath.row]
            let firstName = self.plViewModel.jsonData?.data?.results?.client?.first_name ?? ""
            let lastName = self.plViewModel.jsonData?.data?.results?.client?.last_name ?? ""
            cell.lblName.text = "\(firstName) \(lastName)"
            cell.lblInvoiceNumberAndAmount.text = "\(dict?.invoice_code ?? "")         \(dict?.currency ?? "") \(dict?.amount_of_invoice ?? 0)"
            return cell
        } else if currentIndex == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseOrderTblCell", for: indexPath) as! PurchaseOrderTblCell
            let dict = self.plViewModel.purchaseData?.data?.results?.purchase_details?[indexPath.row]
            cell.lblInvoiceNumber.text = dict?.purchase_code
            cell.lblClientName.text = "\(dict?.client?.first_name ?? "") \(dict?.client?.last_name ?? "")"
            let dateValue = dict?.created_date?.split(separator: "T")
            cell.lblTotalAmount.text = "\(dict?.amount_of_purchase ?? 0)"
            cell.lblCreatedDate.text = "\(dateValue?[0] ?? "")"
            
            return cell
        } else {
           return UITableViewCell()
        }
    }
    
    
}



//MARK: - API CALL
extension P_LSummary: PLFilter{
    func PlFilter(startDate: String, endDate: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.segment.selectedSegmentIndex = 0
        plViewModel.getInvoicesList(projectId: self.projectId ?? 0, startDate: startDate, endDate: endDate) {
            let invoiceData = self.plViewModel.jsonData?.data?.results?.invoices
            if invoiceData?.count ?? 0 > 0 {
                self.tableView.isHidden = false
                self.lblNoData.isHidden = true
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
                self.lblNoData.isHidden = false
            }
        }
        
    }
    
}
