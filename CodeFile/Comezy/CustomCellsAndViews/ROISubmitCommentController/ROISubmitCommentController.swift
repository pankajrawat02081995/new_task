//
//  ROISubmitCommentController.swift
//  Comezy
//
//  Created by aakarshit on 16/06/22.
//

import UIKit

class ROISubmitCommentController: UIViewController, UITextViewDelegate {
    
    var callback: (() -> Void)?
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backgroundView.addGestureRecognizer(tap)
        commentTextField.text = "Write a response here"
        commentTextField.textColor = UIColor.lightGray

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButton(_ sender: Any) {
        commentTextField.endEditing(true)
        print("Comment Cancelled")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func postButton(_ sender: Any) {
        commentTextField.endEditing(true)
        callback?()
        print("CommentAdded")
        
    }
    
    init() {
    super.init(nibName: "ROISubmitCommentController", bundle: Bundle(for: ROISubmitCommentController.self))
    self.modalPresentationStyle = .overCurrentContext
    self.modalTransitionStyle = .crossDissolve
    }
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a response here"
            textView.textColor = UIColor.lightGray
        }
    }
}
