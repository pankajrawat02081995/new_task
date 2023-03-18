//
//  ClientListVC.swift
//  Comezy
//
//  Created by shiphul on 18/11/21.
//

import UIKit

class ClientListVC: UIViewController {
    let objAddProjectModel = AddProjectViewModel.shared
    var loggedInUserOcc: String?
    var projectId: Int?
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var btnAddClient: UIButton!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.navigationBarTitle(headerTitle: "Clients")
        searchField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureTableView()
        getClientList()
        
        loggedInUserOcc = kUserData?.user_type ?? ""

//        getDocsListDetails()
        
        if loggedInUserOcc == UserType.kOwner{
            btnAddClient.isHidden = false
        } else {
            btnAddClient.isHidden = true
        }
        
    }
    
    @IBAction func addClient_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: InviteClientVC()) as! InviteClientVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func configureTableView() {
        tableView.register(UINib(nibName: "PeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "PeopleTableViewCell")
    }
    
    func getClientList(searchParam: String = "") {
        self.objAddProjectModel.getClientList(size: 1000, page: 1, searchParam: searchParam ?? ""){
              (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }else {
                    self.showAlert(message:"not working")
                }
        }
    }
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ClientListVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchField{
            var strSearch = (textField.text ?? "") + string
            if string == ""{
                strSearch = String(strSearch.dropLast())
            }
            if strSearch.count ?? 0 >= 3 {
                //tableView.isHidden = false
                self.getClientList(searchParam: strSearch)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else if strSearch.count == 0{
                self.getClientList()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAddProjectModel.clientListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        cell.btnRemove.isHidden = true
        cell.btnPhone.isHidden = true
        cell.itemClient = objAddProjectModel[atClientList:indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = objAddProjectModel[atClientList:indexPath.row]
        self.objAddProjectModel.objCResult = item//.first_name
        print(item)
        self.navigationController?.popViewController(animated: true)
    }
    
}
