//
//  SpecificationAndProductInformationDetailVC.swift
//  Comezy
//
//  Created by amandeepsingh on 06/07/22.
//

import UIKit

class SpecificationAndProductInformationDetailVC: UIViewController {
    var specificationId: Int?
     var specificationDetail: DocsListModelResult?
     var loggedInUserId: Int?
     var variationDocsArray: [DocsListModelFilesList]?
     var didEdit: Bool?
     var projectId: Int?
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var labelSupplierDetail: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var docsCollectionView: VariationDocsCollView!
    @IBOutlet weak var docsStackVeiw: UIStackView!

    @IBOutlet weak var descriptionToBottom: NSLayoutConstraint!
    
    //MARK: - View Controller Lifecycle method

    override func viewDidLoad() {
           super.viewDidLoad()
               
           loggedInUserId = UserDefaults.getInteger(forKey: "userId")
           // Do any additional setup after loading the view.
       }

    override func viewWillAppear(_ animated: Bool) {
    //    if didEdit == true {

//            SafetyListViewModel.shared.getList(size: "100", page: 1, project_id: projectId ?? 0 , type: "safe_work_method_statement") { success, resp, errorMsg in
                DocsListViewModel().getDocsList(type: "specifications_and_product_information", size: "", page: 1, project_id: projectId ?? 0) { success, resp, errorMsg in
                if success {
                    let specificationDetail = resp?.first(where: { result in
                        result.id == self.specificationId
                    })
                    self.specificationDetail = specificationDetail
                    self.labelName.text = specificationDetail?.name
                    self.labelDescription.text = specificationDetail?.resultDescription
                    self.labelSupplierDetail.text = specificationDetail?.supplierDetails
                    print(specificationDetail?.supplierDetails)
                    self.variationDocsArray = specificationDetail?.filesList
                    print(self.specificationId)
                    print(specificationDetail)
                    print(self.variationDocsArray)
                    DispatchQueue.main.async {
                        self.docsCollectionView.reloadData()
                    }
                    self.initialLoad(createdBy: self.specificationDetail?.createdBy)

                } else {
                    self.showAlert(message: errorMsg)
                }
           
           // }
        }

        
    }
    
    
      override func viewDidLayoutSubviews() {
          self.btnDelete.createGradLayer(color1: UIColor(rgb: 0x1DCDFE), color2: UIColor(rgb: 0x34F5C6))
          self.btnDelete.clipsToBounds = true
      }
      
    //MARK: Initial Load
    func initialLoad(createdBy:Int?) {
          
        let loggedInUserOcc = kUserData?.user_type ?? ""
        let loggedInUserId =  kUserData?.id ?? 0
          
        if loggedInUserOcc == UserType.kWorker || loggedInUserOcc == UserType.kClient {
              if(createdBy == loggedInUserId){
              btnDelete.isHidden = false
              btnEdit.isHidden = false
          } else {
              btnDelete.isHidden = true
              btnEdit.isHidden = true
          }
          }
          
          print(loggedInUserId)
          print(specificationId)
          updateUI()
    
      }
      
      //MARK: Update UI
      func updateUI() {
          let ref = specificationDetail
          variationDocsArray = ref?.filesList
          if variationDocsArray?.count ?? 0 < 1 {
              descriptionToBottom.constant = 20
              docsStackVeiw.isHidden = true
              
          } else {
              docsStackVeiw.isHidden = false
              descriptionToBottom.constant = 150
          }
          docsCollectionView.reloadData()

          labelName.text = ref?.name
          labelDescription.text = ref?.resultDescription
          labelSupplierDetail.text=ref?.supplierDetails

      }
      
    
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    @IBAction func btnEdit_action(_ sender: Any) {
    
        let vc = ScreenManager.getController(storyboard: .main, controller: EditProductInformationVC()) as! EditProductInformationVC
        vc.objSpecificationDetail = self.specificationDetail
        vc.previousRef = self
        vc.specificaitonId = self.specificationId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnDelete_action(_ sender: Any) {
        self.showAppAlert(title: "Delete Product Information?", message: "Do you want to delete this product information") {
                   
                   DocsListViewModel().deleteDocs(document_id: self.specificationId ?? 0) { success, response, errorMsg in
                       if success {
                           self.navigationController?.popViewController(animated: true)
                           self.showToast(message: "Product Information deleted successfully")
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
extension SpecificationAndProductInformationDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variationDocsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = docsCollectionView.dequeueReusableCell(withReuseIdentifier: "VariationDocsCollCell", for: indexPath) as! VariationDocsCollCell
        let item = variationDocsArray?[indexPath.row]
        
        let itemAsURL = URL(string: item?.fileName ?? "Work in progress")
        
            if let safeItemAsURL = itemAsURL {
            let fileName = safeItemAsURL.lastPathComponent
                cell.fileImageView.image = checkFileType(FileName: fileName)
            
        }
        print(item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        vc.docURL = variationDocsArray?[indexPath.row].fileName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
