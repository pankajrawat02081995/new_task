//
//  SafetyWorkMethodDetailVC.swift
//  Comezy
//
//  Created by aakarshit on 28/06/22.
//

import UIKit
import Alamofire

class SafetyWorkMethodDetailVC: UIViewController {

    var safetyId: Int?
    var safetyDetail: SafetyListResult?
    var loggedInUserId: Int?
    var variationDocsArray: [String]?
    var didEdit: Bool?
    var projectId: Int?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var docsCollectionView: VariationDocsCollView!
    @IBOutlet weak var descriptionToBottom: NSLayoutConstraint!
    @IBOutlet weak var docsStackView: UIStackView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loggedInUserId = kUserData?.id
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialLoad()
        if didEdit == true {
            SafetyListViewModel.shared.getList(size: "1000", page: 1, project_id: projectId ?? 0 , type: "safe_work_method_statement") { success, resp, errorMsg in
                
                if success {
                    let safetyDetail = resp?.results.first(where: { result in
                        result.id == self.safetyId
                    })
                    self.safetyDetail = safetyDetail
                    self.lblName.text = safetyDetail?.name
                    self.lblDescription.text = safetyDetail?.resultDescription
                    self.variationDocsArray = safetyDetail?.file
                    print(self.safetyId)
                    print(safetyDetail)
                    print(self.variationDocsArray)
                    DispatchQueue.main.async {
                        self.docsCollectionView.reloadData()
                    }
                } else {
                    self.showAlert(message: errorMsg)
                }
           
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        self.btnDelete.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
        self.btnDelete.clipsToBounds = true
    }
    
    
    //MARK: Initial Load
    func initialLoad() {
        
        let loggedInUserOcc = kUserData?.user_type ?? ""
        
        if loggedInUserOcc == UserType.kOwner {
            btnDelete.isHidden = false
            btnEdit.isHidden = false
        } else {
            btnDelete.isHidden = true
            btnEdit.isHidden = true
        }
        
        print(loggedInUserId)
        print(safetyId)
        updateUI()
  
    }
    
    //MARK: Update UI
    func updateUI() {
        let ref = safetyDetail
        variationDocsArray = ref?.file
        if variationDocsArray?.count ?? 0 < 1 {
            descriptionToBottom.constant = 20
            docsStackView.isHidden = true
        } else {
            docsStackView.isHidden = false
            descriptionToBottom.constant = 150
        }
        docsCollectionView.reloadData()

        lblName.text = ref?.name
        lblDescription.text = ref?.resultDescription

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: Button Actions
    @IBAction func btnEdit_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .safety, controller: EditSafetyWorkMethodVC()) as! EditSafetyWorkMethodVC
        vc.objSafetyDetail = self.safetyDetail
        vc.previousRef = self
        vc.safetyId = self.safetyId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Delete Safety
    @IBAction func btnDelete_action(_ sender: Any) {
        self.showAppAlert(title: "Delete Safety Work Method", message: "Do you want to delete this safety work method") {
            
            SafetyListViewModel.shared.deleteSafety(safetyId: self.safetyId ?? 0) { success, response, errorMsg in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    self.showToast(message: "Safety Work Method deleted successfully")
                }
            }
            
            
//            self.objPunchDetailVM.deletePunch(punchId: self.punchId ?? 0) { success, response, msg in
//                if success {
//                    DispatchQueue.main.async {
//                        self.navigationController?.popViewController(animated: true)
//                        self.showToast(message: "Punch deleted successfully")
//                    }
//                } else {
//                    self.showAlert(message: msg)
//                }
//            }
        }
    }

}

extension SafetyWorkMethodDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variationDocsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = docsCollectionView.dequeueReusableCell(withReuseIdentifier: "VariationDocsCollCell", for: indexPath) as! VariationDocsCollCell
        let item = variationDocsArray?[indexPath.row]
        
        let itemAsURL = URL(string: item ?? "Work in progress")
        
        if let safeItemAsURL = itemAsURL {
            let fileName = safeItemAsURL.lastPathComponent
            cell.fileImageView.image = checkFileType(FileName: fileName)
            
        }
        print(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        vc.docURL = variationDocsArray?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
