//
//  DailyLogDetailVC.swift
//  Comezy
//
//  Created by shiphul on 23/12/21.
//

import UIKit
import CoreMedia
import Kingfisher

class DailyLogDetailVC: UIViewController {
    @IBOutlet weak var lblDate: UILabel!
    var didEdit: Bool?
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var fileCollectionView: UICollectionView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblTempratureMax: UILabel!
    @IBOutlet weak var lblTemperatureCurrent: UILabel!
    @IBOutlet weak var lblWeatherType: UILabel!
    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var editButton: UIButton!
    var arrayPath:URL?
    @IBOutlet weak var lblDocsHeading: UILabel!
    @IBOutlet weak var noCommentsLabel: UILabel!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    let objCommentListViewModel = CommentListViewModel()
    var ProjectId: Int?
    var DailyLogId: Int?
    var itemDailyLogResult = DailyLogResult()
    var myCommentList = [CommentResult]()
    
    @IBOutlet weak var noDocsConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // updateValues()
        getCommentListDetails()
        manageView()
       // if didEdit == true {
        DailyLogListViewModel().getDailyLogList(size: 1000, page: 1, project_id: ProjectId ?? 0) { (success, dailyLogList, error) in
                if success {
                    let dailyLogDetails = dailyLogList?.first(where: { result in
                        result.id == self.DailyLogId
                    })
                    self.itemDailyLogResult = dailyLogDetails!
                    self.updateValues()
                    DispatchQueue.main.async {
                        self.fileCollectionView.reloadData()
                    }
            }
    //}
        }
    }
    func manageView(){
        let loggedInUserOcc = kUserData?.user_type ?? ""

        if loggedInUserOcc == UserType.kOwner || loggedInUserOcc == UserType.kWorker  {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
    }
    func updateValues(){
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: itemDailyLogResult.createdTime ?? "")!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        lblDate.text = dateString
        lblNotes.text = itemDailyLogResult.notes
        let completeTemp = "\(String(describing: itemDailyLogResult.weather!.maximum!))°/\(String(describing: itemDailyLogResult.weather!.current!))°"
        lblAddress.text = itemDailyLogResult.location?.name
        lblTempratureMax.text = completeTemp
        lblWeatherType.text = itemDailyLogResult.weather?.weatherType
        let dateFormatter1 = DateFormatter()
        let tempLocale1 = dateFormatter1.locale // save locale temporarily
        dateFormatter1.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = dateFormatter1.date(from: itemDailyLogResult.createdTime ?? "")!
        dateFormatter1.dateFormat = "hh:mm"
        dateFormatter1.locale = tempLocale // reset the locale
        let dateString1 = dateFormatter1.string(from: date)
        print("EXACT_DATE : \(dateString1)")
        lblTime.text = "As of \(dateString1)"
        imgWeather.image = UIImage(named: itemDailyLogResult.weather?.getImage() ?? "")
        
        if itemDailyLogResult.documents?.count ?? 0 < 1 {
            lblDocsHeading.isHidden == true
            noDocsConstraint.constant = 20
        }
    }
    
    func getCommentListDetails() {
        self.objCommentListViewModel.getCommentList(module: "dailylog_id", module_id: DailyLogId ?? 0, size: 1000, page: 1) { (success, commentList, error) in
                if success {
                    self.myCommentList = commentList ?? [CommentResult]()
                     
                    DispatchQueue.main.async {
                        self.tableViewHeightConstraint.constant = CGFloat(70 * self.myCommentList.count ?? 0)
                        self.tblComment.reloadData()
                        self.toggleCommentLabel()
                    }
                } else {
                    self.showAlert(message: error)
                }
            }
        }

    func toggleCommentLabel() {
        if myCommentList.count == 0 {
            self.tblComment.isHidden = true
            noCommentsLabel.isHidden = false
        } else {
            self.tblComment.isHidden = false
            noCommentsLabel.isHidden = true
        }
    }
    @IBAction func btnBack_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEdit_action(_ sender: Any) {
        print(itemDailyLogResult)
        
        let vc = ScreenManager.getController(storyboard: .main, controller: EditDailyLogVC()) as! EditDailyLogVC
        vc.ProjectId = ProjectId
        vc.dailylog_Id = itemDailyLogResult.id
        vc.editLocation = itemDailyLogResult.location?.name
        vc.editNotes = itemDailyLogResult.notes
        vc.editDocuments = itemDailyLogResult.documents ?? [].self
        vc.arrayPath = arrayPath
       // vc.action = "edited_files"
        vc.item = itemDailyLogResult
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnSeeAllFiles_action(_ sender: Any) {
    }
    @IBAction func btnAddComment_action(_ sender: Any) {
        let vc = AddCommentViewController()
        vc.show()
        vc.callback = {
            
            if vc.commentTextField.text == "Write a comment here" || vc.commentTextField.text == "" || vc.commentTextField.text == "Cannot post an empty comment" {
                vc.commentTextField.text = "Cannot post an empty comment"
            } else {
                self.objCommentListViewModel.getAddComment(controller: self, module: "dailylog", comment: vc.commentTextField.text!, moduleId: self.DailyLogId ?? 0) { success, addTaskList, errorMsg in
                    
                    if success {
                        self.showToast(message: "Comment added successfully", font: .boldSystemFont(ofSize: 14.0))

                        self.getCommentListDetails()
                        
                    }
                }
                vc.dismiss(animated: true)

            }

        }
    }

    
}
extension DailyLogDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDailyLogResult.documents?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotationFilePDFCell", for: indexPath) as! QuotationFilePDFCell
        let item = itemDailyLogResult.documents?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScreenManager.getController(storyboard: .main, controller: WebViewVC()) as! WebViewVC
        vc.docURL = itemDailyLogResult.documents?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let item = myCommentList[indexPath.row]
        if let url = URL(string: ((item.user?.profilePicture)!)!){
            cell.imgUser.kf.setImage(with: url)
            cell.imgUser.contentMode = .scaleAspectFill
        } else {
            cell.imgUser.image = UIImage(systemName: "person.circle.fill")
        }
//        cell.imgUser.image = // UIImage(named: item.user?.profilePicture ?? "")
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: item.createdTime ?? "")!
        dateFormatter.dateFormat = "EE, MMM d"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        print("EXACT_DATE : \(dateString)")
        cell.dateLabel?.text = dateString
        cell.lblUserName.text = item.user?.firstName
        cell.lblComment.text = item.comment
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func configureTableView() {
        tblComment.delegate = self
        tblComment.dataSource = self
        tblComment.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")

}
}
