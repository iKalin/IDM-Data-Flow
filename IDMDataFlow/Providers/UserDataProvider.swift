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

class UserDataProvider: DataProviderProtocol {
    
    func request(parameters: String?, completion: ((Bool, [String: AnyObject]?, Error?) -> ())?) -> (() -> ())? {
        
        let query = parameters ?? "apple"
        
        let apiPath = "https://api.github.com/search/users?q=\(query)"
        let request = Alamofire.request(apiPath, method: .get )
        request.responseJSON { (response) in
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
        
        return {
            request.cancel()
        }

    }
}
