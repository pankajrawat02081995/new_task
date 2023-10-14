//
//  VariationsVC.swift
//  Comezy
//
//  Created by shiphul on 06/12/21.
//


import UIKit

class VariationsVC: UIViewController {
    var ProjectId: Int?
    var loggedInUserOcc: String?
    
    let objVariationsListViewModel = VariationsListViewModel()
    var myVariationList = [VariationsListResult]()
    @IBOutlet weak var lblNoVariations: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tblVariations: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(ProjectId)
        loggedInUserOcc = kUserData?.user_type ?? ""
        getDocsListDetails()
        
        if loggedInUserOcc == UserType.kOwner {
            addButton.isHidden = false
        } else {
            addButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let obj = NotificationsViewModel.shared
        obj.clearBadgeCount(projectId: ProjectId ?? 0, module: "variations") { success, resp, errorMsg in
            if success {
                print("Notification count cleared")
            }
        }
    }
    
    
    func getDocsListDetails() {
        self.objVariationsListViewModel.getVariationsList(size: "1000", page: 1, project_id: ProjectId ?? 0) { (success, docsList, error) in
                if success {
                    self.myVariationList = docsList?.results ?? []
                    self.NoDocs()
                    DispatchQueue.main.async {
                        self.tblVariations.reloadData()
                    }
                } else {
                    self.showAlert(message: error)
                }
            }
        }
    
    func NoDocs(){
        if myVariationList.count == 0{
            lblNoVariations.isHidden = false
            tblVariations.isHidden = true
        }else{
            lblNoVariations.isHidden = true
            tblVariations.isHidden = false
        }
    }
   
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnAddVariaton_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: AddVariationsVC()) as! AddVariationsVC
        vc.ProjectId = ProjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension VariationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myVariationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlansTableViewCell", for: indexPath) as! PlansTableViewCell
        let item = myVariationList[indexPath.row]

        if item.variation_status?.lowercased() == "accepted"{
            cell.lblColorStatus.backgroundColor = App.Colors.appGreenColor
        }else if item.variation_status?.lowercased() == "pending"{
            cell.lblColorStatus.backgroundColor = App.Colors.appOrangeColor
        }else{
            cell.lblColorStatus.backgroundColor = App.Colors.red
        }
        
        cell.lblPlanHeading.text = item.name
        
        cell.lblPlanDescription.text = item.summary
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: item.createdDate ?? "")!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        cell.lblDate.text = dateString
        cell.lblDate.isHidden = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: VariationDetailVC()) as! VariationDetailVC
        vc.variationId = myVariationList[indexPath.row].id
        let item = myVariationList[indexPath.row]

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

            return 150

        }
    
    func configureTableView() {
        tblVariations.register(UINib(nibName: "PlansTableViewCell", bundle: nil), forCellReuseIdentifier: "PlansTableViewCell")
    }
}
