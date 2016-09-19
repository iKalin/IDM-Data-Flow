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

class UsersDataAdapter: NSObject, DataBindingProtocol, UITableViewDataSource {
    
    weak var tableView: UITableView? {
        didSet {
            self.tableView?.dataSource = self
        }
    }
    var users:[User] = []
    
    
    func bindingData(_ parameters: String?, data: Users?) {
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
}
