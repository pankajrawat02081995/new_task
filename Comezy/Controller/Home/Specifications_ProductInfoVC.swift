//
//  specifications_ProductInfoVC.swift
//  Comezy
//
//  Created by shiphul on 07/12/21.
//

import UIKit

class Specifications_ProductInfoVC: UIViewController {
    //MARK: - Variables
    var ProjectId : Int?
    @IBOutlet weak var lblNoList: UILabel!
    let objDocsListViewModel = DocsListViewModel()
    var myDocsList = [DocsListModelResult]()
    @IBOutlet weak var tblSpecs_ProdInfo: UITableView!
    
    //MARK: - View Controller Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDocsListDetails()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NotificationsViewModel.shared.clearBadgeCount(projectId: ProjectId ?? 0, module: "specifications_and_product_information") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    

    //MARK: - On Click Action Method
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAddSpecs_action(_ sender: Any) {
       let vc = ScreenManager.getController(storyboard: .main, controller: AddSpecificationAndProductInfoVC()) as! AddSpecificationAndProductInfoVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - User Defined Functions
    //Method to Get Docs List Detail
    func getDocsListDetails() {
        self.objDocsListViewModel.getDocsList(type: "specifications_and_product_information", size: "1000", page: 1, project_id: ProjectId ?? 0) { (success, docsList, error) in
                if success {
                    self.myDocsList = docsList ?? [DocsListModelResult]()
                    self.noList()
                    DispatchQueue.main.async {
                        self.tblSpecs_ProdInfo.reloadData()
                    }
                }else {
                    self.showAlert(message: error)
                }
            }
        }
    //Method to Hide/Show Empty Text
    func noList(){
        if myDocsList.count == 0{
            lblNoList.isHidden = false
            tblSpecs_ProdInfo.isHidden = true
        }else{
            lblNoList.isHidden = true
            tblSpecs_ProdInfo.isHidden = false
        }
    }
}

//MARK: - Extension Specifications_ProductInfoVC
extension Specifications_ProductInfoVC : UITableViewDelegate, UITableViewDataSource{
    
    func configureTableView() {
        tblSpecs_ProdInfo.register(UINib(nibName: "SpecificationInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "SpecificationInfoTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDocsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationInfoTableViewCell", for: indexPath) as! SpecificationInfoTableViewCell
        let item = myDocsList[indexPath.row]
        cell.lblSpecifiactioName.text = item.name
        cell.lblSpecifiactionDescription.text = item.resultDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: SpecificationAndProductInformationDetailVC()) as! SpecificationAndProductInformationDetailVC
        vc.specificationId=myDocsList[indexPath.row].id
        vc.specificationDetail=myDocsList[indexPath.row]

//        vc.safetyId = myList[indexPath.row].id
//        vc.safetyDetail = myList[indexPath.row]
        vc.projectId = ProjectId
//        let item = myList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}
