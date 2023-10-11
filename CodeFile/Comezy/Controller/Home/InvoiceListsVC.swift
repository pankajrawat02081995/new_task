//
//  InvoiceListsVC.swift
//  Comezy
//
//  Created by Lalit Kumar on 06/06/23.
//

import UIKit

class InvoiceListTblCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInvoiceNumber: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
}

class InvoiceListsVC: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblInvoice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var projectId : Int?
    
    var scheduleVM = InvoiceViewModel()
    var invoiceList = [InvoiceListModel]()
    var startDate: String?
    var endDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segment.selectedSegmentIndex = 2
        
        let name = UserDefaults.standard.value(forKey: "PROJECT_NAME") as? String
        self.lblProjectName.text = name
        
        self.scheduleVM.getInvoiceList(projectId: self.projectId ?? 0, startDate: "", endDate: "", status: "") {
            self.tableView.reloadData()
            if self.scheduleVM.jsonData?.data?.results?.invoices?.count ?? 0 > 0 {
                self.tableView.isHidden = false
                self.lblInvoice.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.lblInvoice.isHidden = false
            }
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        vc.startDate = self.startDate ?? ""
        vc.endDate = self.endDate ?? ""
        self.present(vc, animated: true)
    }
    
    @IBAction func btnAddClicked(_ sender: UIButton) {
        let vc = ScreenManager.getController(storyboard: .main, controller: NewInvoiceVC()) as! NewInvoiceVC
        vc.projectId = self.projectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.scheduleVM.getInvoiceList(projectId: self.projectId ?? 0, startDate: "", endDate: "", status: "1") {
                self.tableView.reloadData()
                if self.scheduleVM.jsonData?.data?.results?.invoices?.count ?? 0 > 0 {
                    self.tableView.isHidden = false
                    self.lblInvoice.isHidden = true
                } else {
                    self.tableView.isHidden = true
                    self.lblInvoice.isHidden = false
                }
            }
        } else if sender.selectedSegmentIndex == 1 {
            
            self.scheduleVM.getInvoiceList(projectId: self.projectId ?? 0, startDate: "", endDate: "", status: "0") {
                self.tableView.reloadData()
                if self.scheduleVM.jsonData?.data?.results?.invoices?.count ?? 0 > 0 {
                    self.tableView.isHidden = false
                    self.lblInvoice.isHidden = true
                } else {
                    self.tableView.isHidden = true
                    self.lblInvoice.isHidden = false
                }
            }
        } else {
            
            self.scheduleVM.getInvoiceList(projectId: self.projectId ?? 0, startDate: "", endDate: "", status: "") {
                self.tableView.reloadData()
                if self.scheduleVM.jsonData?.data?.results?.invoices?.count ?? 0 > 0 {
                    self.tableView.isHidden = false
                    self.lblInvoice.isHidden = true
                } else {
                    self.tableView.isHidden = true
                    self.lblInvoice.isHidden = false
                }
            }
        }
    }
    
    
    
    
}


//MARK: - TABLE VIEW
extension InvoiceListsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleVM.jsonData?.data?.results?.invoices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceListTblCell", for: indexPath) as! InvoiceListTblCell
        let dict = self.scheduleVM.jsonData?.data?.results?.invoices?[indexPath.row]
        let fname = self.scheduleVM.jsonData?.data?.results?.client?.first_name
        let lname = self.scheduleVM.jsonData?.data?.results?.client?.first_name
        cell.lblName.text = "\(fname ?? "") \(lname ?? "")"
        cell.lblInvoiceNumber.text = dict?.invoice_code ?? ""
        cell.lblPrice.text = "\(dict?.currency ?? "") \(dict?.amount_of_invoice ?? 0.0)"
        if let invoiceStatus = dict?.status {
            if invoiceStatus {
                cell.lblStatus.text = "Paid"
                cell.viewStatus.backgroundColor = UIColor.green
            } else {
                cell.lblStatus.text = "Unpaid"
                cell.viewStatus.backgroundColor = UIColor.red
            }
        }
        let strValue = dict?.created_date?.components(separatedBy: "T")
        cell.lblDate.text = strValue?[0]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceDetailsVC") as! InvoiceDetailsVC
        let dict = self.scheduleVM.jsonData?.data?.results?.invoices?[indexPath.row]
        vc.invoiceId = dict?.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - API CALL
extension InvoiceListsVC : InviceFilter{
    func InvoiceFilter(startDate: String, endDate: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.scheduleVM.getInvoiceList(projectId: self.projectId ?? 0, startDate: startDate, endDate: endDate, status: "") {
            if self.scheduleVM.jsonData?.data?.results?.invoices?.count ?? 0 > 0 {
                self.tableView.isHidden = false
                self.lblInvoice.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.lblInvoice.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
    
}
