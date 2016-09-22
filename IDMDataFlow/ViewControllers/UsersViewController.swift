//
//  ViewController.swift
//  IDMDataFlow
//
//  Created by NGUYEN CHI CONG on 8/18/16.
//  Copyright © 2016 NGUYEN CHI CONG. All rights reserved.
//

import UIKit
import MBProgressHUD
import IDMCore

enum LoadStyle : Int {
    case dataBinding = 1
    case integrationCall
}

@IBDesignable
class UsersViewController: UIViewController , UITableViewDataSource {

    @IBInspectable var loadStyle: Int = 1
    @IBOutlet weak var tableView: UITableView!
    
    var integrator = MagicalIntegrator(dataProvider: UserDataProvider(), modelType: Users.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let style = LoadStyle(rawValue: loadStyle)
        switch style! {
        case .dataBinding:
            
            integrator.execute(parameters: "apple", loadingPresenter: self.view, errorAlertPresenter: self, dataBinding: self.listApdater)
            
        case .integrationCall:
            self.tableView.dataSource = self
            
            integrator.prepareCall(parameters: "congnc").onBeginning({
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }).onSuccess({ (users) in
                
                self.users = users?.items ?? []
            }).onError({ (error) in
                
                print("Error: \(error)")
            }).onCompletion({
                
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }).call()
            
            break
        }
    }
    
    //--------------------------------------------------------------------------------
    // //// Style DataBinding
    lazy var listApdater: UsersDataAdapter = {
        let adapter = UsersDataAdapter()
        adapter.tableView = self.tableView
        return adapter
    }()
    // ////
    
    
    //--------------------------------------------------------------------------------
    /// Below code is only used for IntegrationCall
    // //// Style IntegrationCall
    var users: [User] = []
    // ////
    
    
    // //// Style IntegrationCall
    // MARK: - TableView
    @objc func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let user = users[indexPath.row]
        
        let url = URL(string: user.avatarUrl!)
        let imageView = cell.viewWithTag(1) as? UIImageView
        imageView?.sd_setImage(with: url)
        
        let titleLabel = cell.viewWithTag(2) as? UILabel
        titleLabel?.text = user.userName
        
        let homeLabel = cell.viewWithTag(3) as? UILabel
        homeLabel?.text = user.homeUrl
        
        return cell
    }
    
    // ////
}

