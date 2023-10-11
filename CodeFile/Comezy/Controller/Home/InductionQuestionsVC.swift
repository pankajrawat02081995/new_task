//
//  InductionQuestionsVC.swift
//  Comezy
//
//  Created by aakarshit on 29/07/22.
//

import UIKit
import Alamofire

class InductionQuestionsVC: UIViewController {
    
    let objVM = InductionQuestionsViewModel()
    var myList = [InductionResult]()
    let text = "I read and agree to this site rules Terms & Conditions."
    var hasReadTerms = false
    var ownerObj: AllPeopleListElement?
    var arrayOfResponse = [[String: Any]]()
    var callback: ((Bool)->Void)?
    var inductionResponseCallback: (([[String: Any]])->Void)?
    
    
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tblQuestions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        btnSubmit.createGradLayer()
        lblTerms.text = text
        self.lblTerms.textColor =  UIColor.darkGray
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms & Conditions.")
             underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Poppins-Regular", size: 16)!, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue  , range: range1)
        lblTerms.attributedText = underlineAttriString
        lblTerms.isUserInteractionEnabled = true
        lblTerms.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        initialLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func initialLoad() {
        objVM.getInductionQuestions { success, resp, errorMsg in
            if success {
                self.myList = resp?.results ?? []
                self.tblQuestions.reloadData()
            } else {
                self.showToast(message: errorMsg ?? "An error occured! Please try again later.")
            }
        }
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
    let termsRange = (text as NSString).range(of: "Terms & Conditions.")


    if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: termsRange) {
        let vc = ScreenManager.getController(storyboard: .main, controller: TermsWebVC()) as! TermsWebVC
        navigationController?.pushViewController(vc, animated: true)
    }
//    else if gesture.didTapAttributedTextInLabel(label: lblTerms, inRange: privacyRange) {
//        print("Tapped privacy")
//    } else {
//        print("Tapped none")
//    }
    }
    
    @IBAction func btnBack_action(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCheck_action(_ sender: Any) {
        hasReadTerms.toggle()
    }
    @IBAction func btnSubmit_action(_ sender: Any) {
        var allCorrect = false
        for i in myList {
            if i.isCorrect == true {
                
                allCorrect = true
                
            } else {
                allCorrect = false
                break
            }
        }
        
        
        
        if allCorrect && hasReadTerms {
            print(arrayOfResponse)
            inductionResponseCallback?(arrayOfResponse)
            //MARK: @@@@@@@@@@
            self.callback?(true)
            self.navigationController?.popViewController(animated: true)
            self.showToast(message: "You have successfully submitted the correct answers.")
        }
        if !allCorrect && !hasReadTerms {
            self.showToast(message: "All answers need to be correct.")
        }
        if allCorrect && !hasReadTerms {
            self.showToast(message: "Please read and accept the terms.")
        }
        if !allCorrect && hasReadTerms {
            self.showToast(message: "All answers need to be correct.")
        }
        
    }
    

}

//MARK: TableView Delegate

extension InductionQuestionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InductionQuestionCell", for: indexPath) as! InductionQuestionCell
        let item = myList[indexPath.row]
        
        
        if let isCorrect = item.isCorrect {
            if isCorrect {
                cell.lblQuestionDescription.textColor = .systemGreen
                cell.stackResponseBtns.isHidden = true
                cell.questionToBottomConstraint.constant = 20
            } else {
                cell.lblQuestionDescription.textColor = .systemRed
                cell.stackResponseBtns.isHidden = false
                cell.questionToBottomConstraint.constant = 80
            }
        } else {
            cell.lblQuestionDescription.textColor = .black
            cell.stackResponseBtns.isHidden = false
            cell.questionToBottomConstraint.constant = 80
        }
        
        cell.lblQuestionDescription.text = item.question
        
        cell.noCallBack = {
            self.showAppAlert(title: "Mark False Question", message: "Do you want to false this question?") {
                if item.correctAnswer == "NO" {
                    self.myList[indexPath.row].isCorrect = true
                    let response: [String:Any] = ["answer":"NO", "question": item.id]
                    self.arrayOfResponse.append(response)
                    cell.lblQuestionDescription.textColor = .systemGreen
                    self.tblQuestions.reloadData()
                } else {
                    self.myList[indexPath.row].isCorrect = false
                    cell.lblQuestionDescription.textColor = .systemRed
                    self.tblQuestions.reloadData()
                }
            }
 
        }
        
        cell.yesCallBack = {
            self.showAppAlert(title: "Mark True Question", message: "Do you want to true this question?") {
                if item.correctAnswer == "YES" {
                    let response: [String:Any] = ["answer":"YES", "question": item.id]
                    self.arrayOfResponse.append(response)
                    self.myList[indexPath.row].isCorrect = true
                    cell.lblQuestionDescription.textColor = .systemGreen
                    self.tblQuestions.reloadData()
                } else {
                    self.myList[indexPath.row].isCorrect = false
                    cell.lblQuestionDescription.textColor = .systemRed
                    self.tblQuestions.reloadData()
                }
            }

        }
//        cell.lblPlanHeading.text = item.name
        
//        cell.lblPlanDescription.text = item.resultDescription

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ScreenManager.getController(storyboard: .safety, controller: SafetyWorkMethodDetailVC()) as! SafetyWorkMethodDetailVC
//        vc.safetyId = myList[indexPath.row].id
//        vc.safetyDetail = myList[indexPath.row]
//        let item = myList[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

            return 150

        }
    
    func configureTableView() {
        tblQuestions.register(UINib(nibName: "InductionQuestionCell", bundle: nil), forCellReuseIdentifier: "InductionQuestionCell")
    }
}
