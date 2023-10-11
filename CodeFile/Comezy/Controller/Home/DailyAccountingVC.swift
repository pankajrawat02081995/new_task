//
//  DailyAccountingVC.swift
//  Comezy
//
//  Created by Lalit Kumar on 20/08/23.
//

import UIKit

class DailyAccountingVC: UIViewController {
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    
    var scheduleVM = InvoiceViewModel()
    
    var projectId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scheduleVM.getInvoiceList(projectId: self.projectId , startDate: "", endDate: "", status: "") {
            self.tableView.reloadData()
            if self.scheduleVM.jsonData?.data?.results?.invoices?.count ?? 0 > 0 {
                self.tableView.isHidden = false
                self.lblNoData.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.lblNoData.isHidden = false
            }
        }
    }
    
    
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        
    }
    

}


//MARK: - TABLE VIEW
extension DailyAccountingVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleVM.jsonData?.data?.results?.invoices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyInvoiceListTblCell", for: indexPath) as! DailyInvoiceListTblCell
        let dict = self.scheduleVM.jsonData?.data?.results?.invoices?[indexPath.row]
        let fname = self.scheduleVM.jsonData?.data?.results?.client?.first_name
        let lname = self.scheduleVM.jsonData?.data?.results?.client?.first_name
        
        cell.lblName.text = "\(fname ?? "") \(lname ?? "")"
        cell.lblInvoiceId.text = dict?.invoice_code ?? ""
        cell.lblPrivce.text = "\(dict?.currency ?? "") \(dict?.amount_of_invoice ?? 0.0)"
        let strValue = dict?.created_date?.components(separatedBy: "T")
        cell.lblDate.text = strValue?[0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceDetailsVC") as! InvoiceDetailsVC
        let dict = self.scheduleVM.jsonData?.data?.results?.invoices?[indexPath.row]
        vc.invoiceId = dict?.id ?? 0
        vc.isFrom = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return
//    }
    
}
