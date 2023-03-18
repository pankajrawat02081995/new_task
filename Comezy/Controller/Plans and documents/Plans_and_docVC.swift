//
//  Plans_and_docVC.swift
//  Comezy
//
//  Created by MAC on 02/08/21.
//

import UIKit

class Plans_and_docVC: UIViewController {

    @IBOutlet weak var tblPlans_docs: UITableView!
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        // Do any additional setup after loading the view.
    }
    
}

// MARK:- Custom functions -

extension Plans_and_docVC {
    func initialLoad() {
        configureTableView()
        self.navigationBarTitle(headerTitle: "\(type)", backTitle: "")
    }
    
    func configureTableView() {
        tblPlans_docs.delegate = self
        tblPlans_docs.dataSource = self
        tblPlans_docs.register(UINib(nibName: "PlansTableViewCell", bundle: nil), forCellReuseIdentifier: "PlansTableViewCell")
        tblPlans_docs.register(UINib(nibName: "DocumentsTableViewCell", bundle: nil), forCellReuseIdentifier: "DocumentsTableViewCell")
    }
}

extension Plans_and_docVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == "Plans" {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlansTableViewCell", for: indexPath) as! PlansTableViewCell
        return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsTableViewCell", for: indexPath) as! DocumentsTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
