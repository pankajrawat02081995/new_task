//
//  AllPeopleVC.swift
//  Comezy
//
//  Created by aakarshit on 24/05/22.
//

import Foundation
import UIKit
import Kingfisher

class AllPeopleVC: UIViewController {
    
    let objAllPeopleListViewModel = AllPeopleListViewModel.shared
    var ProjectId: Int?
    var checked = false
    var selectedPeople = [Int]()
    var selectedFromId: Int?
    var fromComponent: String?
    var selectedFromCallback: ((AllPeopleListElement) -> ())?
    var selectedToCallback: (([SelectedReceiver]) -> ())?
    var selectedRecievers = [SelectedReceiver]()
    var textFieldRef: UITextField?
    var addSiteRiskVCRef: AddSiteRiskVC?
    var allSelected = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBOutlet weak var searchField: UITextField!

    
    
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var allPeopleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromComponent == "btnAddTo" {
            btnSelect.isHidden = false
        } else {
            btnSelect.isHidden = true
        }
        
        if selectedRecievers.count == objAllPeopleListViewModel.allPeopleListDataDetail.count {
            allSelected = true
            btnSelect.setTitle("Deselect All", for: .normal)
        } else {
            allSelected = false
            btnSelect.setTitle("Select All", for: .normal)

        }
        searchField.delegate = self

        configureTableView()

    }
    //MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        textFieldRef?.endEditing(true)
        
        for i in selectedRecievers {
            print(i.receiverId)
        }
        
        DispatchQueue.main.async {
            print()
            self.allPeopleTableView.reloadData()
        }
//        objAllPeopleListViewModel.allPeopleListDataDetail = []
        getAllPeopleListDetail()
        btnDone.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        btnDone.clipsToBounds = true
    }
    
  
    
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Button Done
    @IBAction func btnDone_action(_ sender: UIButton) {
        if selectedRecievers.count > 0 {

            
            print(selectedRecievers, "@#$@#$%@#$%@#$  Selected Reveivers  @#$@#$@!@$!@$")
            selectedToCallback?(selectedRecievers)
            navigationController?.popViewController(animated: true)
        } else {
            self.showAlert(message: "Please select atleast one person.")
        }
        
    }
    
    @IBAction func btnSelectAll_action(_ sender: Any) {
        
        if !allSelected {
            selectedRecievers = []
            for i in objAllPeopleListViewModel.allPeopleListDataDetail {
                selectedRecievers.append(SelectedReceiver(receiverId: i.id, checked: true, person: i))
            }
            allSelected = true
            btnSelect.setTitle("Deselect All", for: .normal)
            tableView.reloadData()

        } else {
            selectedRecievers = []
            allSelected = false
            btnSelect.setTitle("Select All", for: .normal)
            tableView.reloadData()

        }

    }
    
    
    //MARK: Get All People List
    func getAllPeopleListDetail() {
        self.objAllPeopleListViewModel.getAllPeopleList(project_id: ProjectId ?? 0) { success, peopleList, errorMsg in
            if success {
                //Removing the selected sender from all people list
                if self.fromComponent == "btnAddTo" {
                    self.objAllPeopleListViewModel.allPeopleListDataDetail.removeAll { person in
                        person.id == self.selectedFromId
                        
                    }
                }
                self.objAllPeopleListViewModel.allPeopleSearchedListDataDetail = self.objAllPeopleListViewModel.allPeopleListDataDetail
                print(self.objAllPeopleListViewModel.allPeopleSearchedListDataDetail )

                DispatchQueue.main.async {
                    self.allPeopleTableView.reloadData()
                }
            } else {
                self.showAlert(message: errorMsg)
            }
        }
    }
    
    //MARK: Button Done visible
    func doneButtonVisible() {
        if fromComponent == "txtFrom" {
            btnDone.isHidden = true
        } else if fromComponent == "btnAddTo" {
            btnDone.isHidden = false
        }
    }
    
    func noPeople() {
        
    }
    
    
    
}
//MARK: TableView Delegate
extension AllPeopleVC : UITableViewDelegate, UITableViewDataSource {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchField{
            var strSearch = (textField.text ?? "") + string
            if string == ""{
                strSearch = String(strSearch.dropLast())
            }
            print(strSearch)
            if strSearch.count ?? 0 >= 3 {
                //tableView.isHidden = false
               // self.getClientList(searchParam: strSearch)
                self.objAllPeopleListViewModel.allPeopleListDataDetail = []
print(self.objAllPeopleListViewModel.allPeopleSearchedListDataDetail)
                self.objAllPeopleListViewModel.allPeopleSearchedListDataDetail.filter { data in
                    print("CONTAIN",data.firstName.contains(strSearch))
                    

                    if(data.firstName.contains(strSearch)){
                        self.objAllPeopleListViewModel.allPeopleListDataDetail.append(data)

                    }
                    
                    return data.firstName.contains(strSearch)
                }
                print("SEARCH?ED",self.objAllPeopleListViewModel.allPeopleListDataDetail)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else if strSearch.count == 0{
                self.objAllPeopleListViewModel.allPeopleListDataDetail = []

                self.getAllPeopleListDetail()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        return true
    }
    
    func configureTableView() {
        doneButtonVisible()
        //        tableView.contentInsetAdjustmentBehavior = .never
        allPeopleTableView.delegate = self
        allPeopleTableView.dataSource = self
        allPeopleTableView.register(UINib(nibName: "AllPeopleCell", bundle: nil), forCellReuseIdentifier: "AllPeopleCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objAllPeopleListViewModel.allPeopleListDataDetail.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = allPeopleTableView.dequeueReusableCell(withIdentifier: "AllPeopleCell", for: indexPath) as! AllPeopleCell
        cell.item = objAllPeopleListViewModel.allPeopleListDataDetail[indexPath.section]
        if let url = URL(string: (objAllPeopleListViewModel.allPeopleListDataDetail[indexPath.section].profilePicture)){
            cell.imgProfile.kf.setImage(with: url)
            cell.imgProfile.contentMode = .scaleAspectFill
        }
        
        
        cell.tintColor = UIColor(named: "AppGreenColor")
        cell.checkMark.isHidden = true
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 16
        
        if fromComponent == "btnAddTo" {
            var currentReceiver = objAllPeopleListViewModel.allPeopleListDataDetail[indexPath.section]
            
            
            if !selectedRecievers.isEmpty {
                let currentReceiverInSelectedReceivers = selectedRecievers.firstIndex { person in
                    person.receiverId == currentReceiver.id
                }
                print(selectedRecievers)
                if let safePlay = currentReceiverInSelectedReceivers, let isChecked = selectedRecievers[safePlay].checked {
                    print("It ran")
                    print(isChecked)
                    print(selectedRecievers[safePlay].checked )
                    if isChecked {
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }

                } else {
                    cell.accessoryType = .none
                }
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
        
    }
    
    //MARK: DidSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currentReceiver = objAllPeopleListViewModel.allPeopleListDataDetail[indexPath.section]
        //IF from ButtonAddTo Button for selection of "TO"
        if fromComponent == "btnAddTo" {
            let selectedCell = tableView.cellForRow(at: indexPath)
            selectedCell?.selectionStyle = .none
            
            if selectedCell?.accessoryType == UITableViewCell.AccessoryType.none {
                
                selectedRecievers.append(SelectedReceiver(receiverId: currentReceiver.id, checked: true, person: currentReceiver))
                selectedCell?.accessoryType = .checkmark
                
            } else {
                selectedRecievers.removeAll { person in
                    person.receiverId == currentReceiver.id
                }
                selectedCell?.accessoryType = .none
            }
            
            if selectedRecievers.count == objAllPeopleListViewModel.allPeopleListDataDetail.count {
                allSelected = true
                btnSelect.setTitle("Deselect All", for: .normal)
            } else {
                allSelected = false
                btnSelect.setTitle("Select All", for: .normal)
            }
            //IF from txtFrom TextField for selection of "FROM"
        } else if fromComponent == "txtFrom" {
            let person = objAllPeopleListViewModel.allPeopleListDataDetail[indexPath.section]
            selectedFromCallback?(person)
            if addSiteRiskVCRef != nil {
                addSiteRiskVCRef?.personSelected = true
            }
            navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    
}

extension AllPeopleVC: UITextFieldDelegate {
    
}

