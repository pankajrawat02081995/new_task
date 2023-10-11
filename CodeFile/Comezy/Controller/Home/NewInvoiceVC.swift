//
//  NewInvoiceVC.swift
//  Comezy
//
//  Created by Lalit Kumar on 07/06/23.
//

import UIKit
import DropDown

struct ItemsList {
    let name: String
    let amount: String
    let quantity: Int
    let hasValue: Bool
    let currency: String
    
    init(name: String, amount: String, quantity: Int, hasValue: Bool, currency: String ) {
        self.name = name
        self.amount = amount
        self.quantity = quantity
        self.hasValue = hasValue
        self.currency = currency
        
    }
}

struct InvoiceAdd {
    let terms: String
    let tax_rate: Int
    let tax: String
    let project: String
    let customer: String
    let name: String
}

protocol ReloadData {
    func reload()
}

var reloadData: ReloadData?

class ItemsListTblCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    
    
    override class func awakeFromNib() {
        
    }
    
    var callBack:(()->())?
    var moreCallBack:(()->())?
    
    
    @IBAction func btnAddClicked(_ sender: UIButton) {
        self.callBack?()
    }
    
    
    @IBAction func btnMoreClicked(_ sender: UIButton) {
        self.moreCallBack?()
    }
    
    
    
    
}



class NewInvoiceVC: UIViewController {
    
    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtTerms: UITextField!
    @IBOutlet weak var txtBuilderAddress: UITextField!
    @IBOutlet weak var txtTexRate: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var txtTaxName: UITextField!
    @IBOutlet weak var lblSubTotalData: UILabel!
    
    @IBOutlet weak var termsTextView: UITextView!
    
    
    var arrItems = [ItemsList]()
    let dropDown = DropDown()
    var projectId : Int?
    var viewModel = NewInvoiceViewModel()
    var arrAmount = [Int]()
    
    var currentIndex = 0
    var arrDataSource = ["Brick cal", "Steel", "Steel 1", "Steel 2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtTexRate.delegate = self
        let newData = ItemsList.init(name: "Item name", amount: "", quantity: 0, hasValue: false, currency: "USD")
        self.arrItems.append(newData)
        
        reloadData = self
        
        let clientName = UserDefaults.standard.value(forKey: "CLIENT_NAME") as? String
    
        let projectName = UserDefaults.standard.value(forKey: "PROJECT_NAME") as? String
        self.lblClientName.text = clientName
        self.lblProjectName.text = projectName
        
    }
    
   
    
    @IBAction func btnAddMoreClicked(_ sender: UIButton) {
        
        print(self.arrItems.last)
        
        if self.arrItems != nil {
            if let lastIndex = self.arrItems.last {
                print(lastIndex)
                if lastIndex.amount != "" {
                    let newData = ItemsList.init(name: "Item name", amount: "", quantity: 0, hasValue: false, currency: "USD")
                    self.arrItems.append(newData)
                    self.tableView.reloadData()
                    self.viewHeightConstraint.constant = CGFloat(40 * (self.arrItems.count))
                }
                
            }
        }
        
    }
        
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
   
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        if self.termsTextView.text?.isEmpty == true {
            self.showAlert(message: "Please enter terms")
        } else if self.txtTexRate.text?.isEmpty == true {
            self.showAlert(message: "Please enter tax rate")
        } else if self.txtTaxName.text?.isEmpty == true {
            self.showAlert(message: "Please enter tax name")
        } else if self.txtNote.text.isEmpty == true {
            self.showAlert(message: "Please enter notes")
        } else {
             
            let id = UserDefaults.standard.value(forKey: "ID") as? Int ?? 0
            let rate = Int(self.txtTexRate.text ?? "")
            let request = InvoiceAdd(terms: self.termsTextView.text ?? "",
                                     tax_rate: rate ?? 0,
                                     tax: self.txtTaxName.text ?? "",
                                     project: "\(self.projectId ?? 0)",
                                     customer:  String(id),
                                     name: self.lblClientName.text ?? "")
            
            print(request)
            
            
            self.viewModel.addInvoice(arr: self.arrItems, req: request, completionHandler: { status, invoiceModel, errorMsg in
                if status {
                    self.showAlert(message: "Invoice added sucessfully!") {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } else {
                    self.showAlert(message: errorMsg)
                }
            })
            
        }
    }
    

}


extension NewInvoiceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsListTblCell", for: indexPath) as! ItemsListTblCell
        cell.lblName.text = self.arrItems[indexPath.row].name
//        if let indexValue = self.arrItems.last {
//            if indexValue.first == indexPath.row {
//                cell.btnMore.isHidden = true
//            } else {
//                cell.btnMore.isHidden = false
//            }
//        }
        cell.btnMore.tag = indexPath.row
        if self.arrItems.count > 1 {
            if indexPath.row == self.arrItems.count - 1 {
                cell.btnMore.isHidden = true
            } else {
                cell.btnMore.isHidden = false
            }
        } else {
            cell.btnMore.isHidden = true
        }
        self.viewHeightConstraint.constant = CGFloat(40 * (self.arrItems.count))
        
        
        cell.callBack = { [weak self] in
//            let newData = ItemsList.init(name: "Item name", amount: "", quantity: 0, hasValue: false)
//            self?.arrItems.append(newData)
//            self?.tableView.reloadData()
//            self?.viewHeightConstraint.constant = CGFloat(40 * (self?.arrItems.count ?? 0))
            
        }
        
        cell.moreCallBack = { [weak self] in
            self?.presentActionSheet(options: ["Edit", "Delete", "Cancel"], completion: { action in
                if action == "Delete" {
                    self?.arrItems.remove(at: indexPath.row)
                    self?.tableView.reloadData()
                } else if action == "Edit" {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "AddItemDetailsVC") as! AddItemDetailsVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
//                    vc.name = item
                    vc.model = self?.arrItems[indexPath.row]
                    vc.isUpdate = true
                    vc.callBack = { req in
                        if let reqValue = req {
                            self?.arrItems[indexPath.row] = reqValue
                        }
                        self?.tableView.reloadData()
                    }
                    self?.present(vc, animated: true)
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        self.currentIndex = indexPath?.row ?? 0
        
        let itemAtIndex = self.arrItems[indexPath?.row ?? 0]
        if !self.arrDataSource.contains(itemAtIndex.name) {
            
            self.dropDown.anchorView = currentCell
            self.dropDown.dataSource = self.arrDataSource
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddItemDetailsVC") as! AddItemDetailsVC
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.name = item
                vc.callBack = { req in
                    if let reqValue = req {
                        self.arrItems.insert(reqValue, at: self.currentIndex)
                    }
                }
                self.present(vc, animated: true)
            }
            self.dropDown.show()
        } else {
            print("has Value")
        }
        
    }
    
    
    
    
}


//MARK: - CUSTOM DELEGATE
extension NewInvoiceVC: ReloadData {
    
    func reload() {
        var taxAmount = "0.0"
        var totalAmount = "0.0"
        var grandTotal = "0.0"
        self.arrAmount.removeAll()
        
        
        self.arrItems.forEach { itemsValue in
            
                let amount = Int(itemsValue.amount)
                let quantity = itemsValue.quantity
                let total = ((amount ?? 0) * quantity)
                self.arrAmount.append(total)
                
                if self.txtTexRate.text?.isEmpty == true {
                    self.lblSubTotalData.text = "\(total)\n0.0\n0.0"
                } else {
                    
                    
                    
                }
            
            
            
        }
        var intAmount = 0
        self.arrAmount.forEach { amou in
            intAmount += amou
        }
        totalAmount = String(intAmount)
        
        let intTax = Int(self.txtTexRate.text ?? "")
        let texValue = (intAmount * (intTax ?? 0))/100
        taxAmount = String(texValue)
        
        let subtotal = intAmount + texValue
        grandTotal = String(subtotal)
        
        
        self.lblSubTotalData.text = "\(totalAmount)\n\(taxAmount)\n\(grandTotal)"
        self.tableView.reloadData()
    }
    
}



//MARK: - UITEXTFIELD DELEGATE
extension NewInvoiceVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var taxAmount = "0.0"
        var totalAmount = "0.0"
        var grandTotal = "0.0"
        self.arrAmount.removeAll()
        
        
        self.arrItems.forEach { itemsValue in
            if itemsValue.amount != "" {
                let amount = Int(itemsValue.amount)
                let quantity = itemsValue.quantity
                let total = ((amount ?? 0) * quantity)
                self.arrAmount.append(total)
                
                if self.txtTexRate.text?.isEmpty == true {
                    self.lblSubTotalData.text = "\(total)\n0.0\n0.0"
                } else {
                    
                    
                    
                }
            }
            
            
        }
        var intAmount = 0
        self.arrAmount.forEach { amou in
            intAmount += amou
        }
        totalAmount = String(intAmount)
        
        let intTax = Int(self.txtTexRate.text ?? "")
        let texValue = (intAmount * (intTax ?? 0))/100
        taxAmount = String(texValue)
        
        let subtotal = intAmount + texValue
        grandTotal = String(subtotal)
        
        
        self.lblSubTotalData.text = "\(totalAmount)\n\(taxAmount)\n\(grandTotal)"
    }
}

