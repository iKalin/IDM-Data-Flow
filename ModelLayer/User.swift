//
//  User.swift
//  IDMDataFlow
//
//  Created by NGUYEN CHI CONG on 8/18/16.
//  Copyright © 2016 NGUYEN CHI CONG. All rights reserved.
//

import Foundation
import IDMCore

public class Users: ModelProtocol {
    public var items: [User]?
    public required init(dictionary: [String : AnyObject]?) {
        guard dictionary != nil else {return}
        guard let items = dictionary!["items"] as? [[String: AnyObject]] else {
            return
        }
        var users:[User] = []
        
        for item in items {
            let u = User(dictionary: item)
            users.append(u)
        }
        self.items = users
    }
}

public class User: ModelProtocol {
    public var userName: String?
    public var avatarUrl: String?
    public var homeUrl: String?
    
    public required init(dictionary: [String : AnyObject]?) {
        guard dictionary != nil else {return}
        
        let userName = dictionary!["login"] as? String
        let url = dictionary!["avatar_url"] as? String
        let homeUrl = dictionary!["html_url"] as? String
        
        self.userName = userName
        self.avatarUrl = url
        self.homeUrl = homeUrl
    }
}
