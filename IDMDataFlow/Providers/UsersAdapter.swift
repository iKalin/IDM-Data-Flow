//
//  UsersAdapter.swift
//  IDMDataFlow
//
//  Created by NGUYEN CHI CONG on 8/18/16.
//  Copyright © 2016 NGUYEN CHI CONG. All rights reserved.
//

import Foundation
import SDWebImage
import IDMCore
import IntegrationLayer
import ModelLayer

class UsersDataAdapter: DefaultDataBinding<[String : AnyObject],Users>, UITableViewDataSource {
    
    required init() {}
    
    weak var tableView: UITableView? {
        didSet {
            self.tableView?.dataSource = self
        }
    }
    var users:[User] = []
    
    
    override func bindingData(parameters: [String : AnyObject]?, data: Users?) {
        defer {
            self.tableView?.reloadData()
        }
        guard data?.items != nil else {
            users = []
            return
        }
        self.users = data!.items!
    }
    
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
}
