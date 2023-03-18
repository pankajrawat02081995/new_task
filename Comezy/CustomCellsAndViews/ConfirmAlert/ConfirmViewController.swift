//
//  ConfirmViewController.swift
//  Comezy
//
//  Created by aakarshit on 09/06/22.
//

import UIKit

class ConfirmViewController: UIViewController {
    var callback: (() -> Void)?
    var noCallBack: (() -> Void)?
    
    @IBOutlet weak var confirmHeadingLabel: UILabel!
    @IBOutlet weak var confirmDescriptionLabel: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        backgroundView.addGestureRecognizer(tap)
        super.viewDidLoad()
        // Do   any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        btnYes.createGradLayer()
        btnYes.clipsToBounds = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnYes_action(_ sender: Any) {
        callback?()
        print("Command confirmed")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnNo_action(_ sender: Any) {
        noCallBack?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    init() {
    super.init(nibName: "ConfirmViewController", bundle: Bundle(for: ConfirmViewController.self))
    self.modalPresentationStyle = .overCurrentContext
    self.modalTransitionStyle = .crossDissolve
    }
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }

    
}
