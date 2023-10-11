//
//  CompletedInductionVC.swift
//  Comezy
//
//  Created by amandeepsingh on 10/08/22.
//

import UIKit

class CompletedInductionVC: UIViewController {
    var loggedInUserOcc: String?
    var ProjectId: Int?
    var userId:Int?
    var safetyCard:String = ""
    var tradingLicense:String = ""
    var workerDetails: PeopleClient?

    let objVM = InductionQuestionsViewModel()
    @IBOutlet weak var tradingStack: UIStackView!
    var myList = [InductionAnswerResponseResult]()
    @IBOutlet weak var safetyImage: UIImageView!
    @IBOutlet weak var tradingImage: UIImageView!
    @IBOutlet weak var safetyStack: UIStackView!
    @IBOutlet weak var lblNoInductionCompleted: UILabel!
    @IBOutlet weak var tblInduction: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(ProjectId as Any, "Printing project ID from <============== Induction VC")
        getDocsListDetails(userId:self.userId!)
        loggedInUserOcc = kUserData?.user_type ?? ""
//        print(workerDetails?.safetyCard)
//        print(workerDetails?.tradingLicense)
//        if let url = URL(string: workerDetails?.safetyCard ?? "https://s3.us-east-2.amazonaws.com/comezyandroidd9188d0503e4419a82be1cd838c6264c13733-dev/public/quotationFiles/quotation/IMG_1660159688769.png"){
//            print("Safety Card ->", url)
//            safetyImage.kf.setImage(with: url)
//            safetyImage.contentMode = .scaleAspectFill
//        }
//
//        if let url = URL(string: workerDetails?.tradingLicense ?? ""){
//            tradingImage.kf.setImage(with: url)
//            tradingImage.contentMode = .scaleAspectFill
//        }
        if(workerDetails?.tradingLicense!.isEmpty==true){
            tradingStack.isHidden = true
        }
        if(workerDetails?.safetyCard!.isEmpty==true){
            safetyStack.isHidden = true
        }

    }
    
    func getDocsListDetails(userId:Int) {
        
        self.objVM.getCompletedInductionResponse(userId:userId ) { success, resp, error in
                if success {
                    
                    
                    self.myList = resp?.results ?? []
                    self.NoDocs()
                    DispatchQueue.main.async {
                        self.tblInduction.reloadData()
                        
                    }
                    
                } else {
                    self.showAlert(message: error)
                }
            }
        }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnSafetyCard_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        vc.docURL = workerDetails?.safetyCard ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTradingLic_action(_ sender: Any) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        vc.docURL = workerDetails?.tradingLicense ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func NoDocs(){
        if myList.count == 0{
            lblNoInductionCompleted.isHidden = false
            tblInduction.isHidden = true
        }else{
            lblNoInductionCompleted.isHidden = true
            tblInduction.isHidden = false
        }
    }

}
extension CompletedInductionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteInductionCell", for: indexPath) as! CompleteInductionCell
        let item = myList[indexPath.row]
        cell.lblquestion.text = item.question.question
        if(item.answer == "YES"){
        cell.lblResponse.text = item.answer
            cell.lblResponse.textColor = .green
        }
        else if (item.answer == "NO"){
            cell.lblResponse.text = item.answer
            cell.lblResponse.textColor = .red

        }
        else{
            cell.lblResponse.text = item.answer
            cell.lblResponse.textColor = .yellow

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        }
  
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

            return 200

        }
    
    func configureTableView() {
        tblInduction.register(UINib(nibName: "CompleteInductionCell", bundle: nil), forCellReuseIdentifier: "CompleteInductionCell")
    }
}
