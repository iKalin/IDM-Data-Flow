//
//  ViewController.swift
//  IDMDataFlow
//
//  Created by NGUYEN CHI CONG on 8/18/16.
//  Copyright © 2016 NGUYEN CHI CONG. All rights reserved.
//

import UIKit
import MBProgressHUD
import ModelLayer

enum LoadStyle : Int {
    case DataBinding = 1
    case IntegrationCall
}

@IBDesignable
class UsersViewController: UIViewController , UITableViewDataSource {

    @IBInspectable var loadStyle: Int = 1
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dataProvider: UsersProvider = UsersProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let style = LoadStyle(rawValue: loadStyle)
        switch style! {
        case .DataBinding:
            dataProvider.supply(loadingPresenter: self.view, errorAlertPresenter: self, dataBinding: self.listApdater)
        case .IntegrationCall:
            self.tableView.dataSource = self
            dataProvider.defaultIntegration.prepareCall().onBeginning({
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            }).onSuccess({ (users) in
                self.users = users?.items ?? []
                self.tableView.reloadData()
            }).onError({ (error) in
                print("Error: \(error)")
            }).onCompletion({ 
                MBProgressHUD.hideHUDForView(self.view, animated: true)
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
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let user = users[indexPath.row]
        
        let url = NSURL(string: user.avatarUrl!)
        let imageView = cell.viewWithTag(1) as? UIImageView
        imageView?.sd_setImageWithURL(url)
        
        let titleLabel = cell.viewWithTag(2) as? UILabel
        titleLabel?.text = user.userName
        
        let homeLabel = cell.viewWithTag(3) as? UILabel
        homeLabel?.text = user.homeUrl
        
        return cell
    }
    
    // ////
}

