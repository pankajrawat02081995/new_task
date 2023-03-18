//
//  DocsVC.swift
//  Comezy
//
//  Created by shiphul on 03/12/21.
//

import UIKit

class DocsVC: UIViewController {
    var ProjectId: Int?
    @IBOutlet weak var tblDocs: UITableView!
    var objBadgeCountModel: NotificationBadgeCountModel?
    
    var arrayOfItems : [Item]=[Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfItems = APIClient().getData()
        configureTableView()

      
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBadgeCount()
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadBadgeCount() {
        objBadgeCountModel = NotificationsViewModel.shared.objBadgeCount
        print(objBadgeCountModel)
        self.tblDocs.reloadData()
    }

    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHome_action(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
extension DocsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DocsCell") as? DocsCell {
         cell.configureCell(item: arrayOfItems[indexPath.row])
            if(kUserData?.user_type != UserType.kOwner){

            if let obj = objBadgeCountModel?.allCount.docs {
                
                if indexPath.row == 0 && obj.variations > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.variations)"
                } else if indexPath.row == 0 && obj.variations == 0 {
                    cell.lblCount.isHidden = true
                }
                
                if indexPath.row == 1 && obj.specificationsAndProductInformation > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.specificationsAndProductInformation)"
                } else if indexPath.row == 1 && obj.specificationsAndProductInformation == 0 {
                    cell.lblCount.isHidden = true
                }
                
                if indexPath.row == 2 && obj.safety.safetyTotal > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.safety.safetyTotal)"
                } else if indexPath.row == 2 && obj.safety.safetyTotal == 0 {
                    cell.lblCount.isHidden = true
                }
                
                if indexPath.row == 3 && obj.general.generalTotal > 0 {
                    cell.lblCount.isHidden = false
                    cell.lblCount.text = "\(obj.general.generalTotal)"
                } else if indexPath.row == 3 && obj.general.generalTotal == 0 {
                    cell.lblCount.isHidden = true
                }
            }}
            else{
                cell.lblCount.isHidden = true

            }

           return cell
        }
    return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            showWorkInProgress()
//
            let vc = ScreenManager.getController(storyboard: .main, controller: VariationsVC()) as! VariationsVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1 {
//            showWorkInProgress()
            let vc = ScreenManager.getController(storyboard: .main, controller: Specifications_ProductInfoVC()) as! Specifications_ProductInfoVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {

            let vc = ScreenManager.getController(storyboard: .safety, controller: SafetyListVC()) as! SafetyListVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 3 {
            let vc = ScreenManager.getController(storyboard: .general, controller: GeneralVC()) as! GeneralVC
            vc.ProjectId = ProjectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func configureTableView() {
        tblDocs.register(UINib(nibName: "DocsCell", bundle: nil), forCellReuseIdentifier: "DocsCell")
    }
    
}

