//
//  UserDataLayer.swift
//  IDMDataFlow
//
//  Created by NGUYEN CHI CONG on 8/18/16.
//  Copyright © 2016 NGUYEN CHI CONG. All rights reserved.
//

import Foundation
import Alamofire
import IDMCore

public final class UserData: NSObject, DataProtocol {
    
    public func request(parameters parameters:[String: AnyObject]? = nil , completion: DataCompletionClosure? = nil) {
        let apiPath = "https://api.github.com/search/users?q=apple"
        Alamofire.request(.GET, apiPath).responseJSON { (response) in
            var success = true
            var data: [String: AnyObject]? = nil
            var error: NSError? = nil
            
            let value = response.result.value
            guard value != nil else {
                return
            }
            data = value as? [String: AnyObject]
            
            defer {
                completion?(success, data, error)
            }
        }
    }
}