# README #

This is a sample which conforms IDM Data Flow.

# IDMCore

Integrator - Data Provider - Model : Make your iOS MVC application cleaner.

IDMCore is an implementation of the unidirectional data flow architecture in Swift. IDMCore helps you to separate three important concerns of your data flow components:

* **Model** : model of data used in controller to render views.
* **DataProvider** : provides methods to retrieve data from the storage source or initialization data.
* **Integrator** : dispatches integration call to Data Providers and retrieve the desired data model.
 
![alt text](http://i.imgur.com/Bw0caQ8m.png "IDMCore")

### Requirements
  - XCode 8+, Swift 3+
  - iOS 8+

### Installation
IDMCore is available through CocoaPods. To install it, simply add the following line to your Podfile:

```ruby
pod 'IDMCore'
```

### Getting started

**1. Create a Data provider to fetch data**

A Data provider conforms `DataProviderProtocol`. You need implement `request` method to get data, which specify input parameters type and ouput data type. This also return a closure, which can cancel request.

```swift
func request(parameters: <#input_type#>?, completion: ((Bool, <#output_type#>?, Error?) -> ())?) -> (() -> ())?
```

Example:

```swift
struct UserDataProvider: DataProviderProtocol {
    func request(parameters: String?, completion: ((Bool, [String: AnyObject]?, Error?) -> ())?) -> (() -> ())? {
        let query = parameters ?? "default"
        let apiPath = "https://api.github.com/search/users?q=\(query)"
        let request = Alamofire.request(apiPath, method: .get )
        request.responseJSON { (response) in
            var success = true
            var data: [String: AnyObject]? = nil
            var error: NSError? = nil
            defer {
                completion?(success, data, error)
            }
            let value = response.result.value
            guard value != nil else {
                return
            }
            data = value as? [String: AnyObject]
        }
        return {
            request.cancel()
        }
    }
}
```

**2. Create a Model**

A Model conforms `ModelProtocol`. You maybe implement `init(from:)` method to parse data.
```swift
init?(from data: <#input_data_type#>?)
```

Example:

```swift
struct Users: ModelProtocol {
    
    var items: [User]?
    
    init(from data: [String : AnyObject]?) {
        guard data != nil else {return}
        guard let items = data!["items"] as? [[String: AnyObject]] else {
            return
        }
        var users:[User] = []
        
        for item in items {
            let u = User(from: item)
            users.append(u)
        }
        self.items = users
    }
}

struct User: ModelProtocol {

    var userName: String?
    var avatarUrl: String?
    var homeUrl: String?
    
    init(from data: [String : AnyObject]?) {
        guard data != nil else {return}
        
        let userName = data!["login"] as? String
        let url = data!["avatar_url"] as? String
        let homeUrl = data!["html_url"] as? String
        
        self.userName = userName
        self.avatarUrl = url
        self.homeUrl = homeUrl
    }
}
```

**3. Integrate with Controller**

A Integrator like an use case of data flow. Declare an integrator & initialize with Data provider & Model type.

```swift
class UsersViewController: UIViewController , UITableViewDataSource {
[...]
var integrator = MagicalIntegrator(dataProvider: UserDataProvider(), modelType: Users.self)
}
```

Call integrator to get data & handle returned model:

```swift
            integrator
                .prepareCall(parameters: "apple")
                .onBeginning({
                    print("Show loading here")
                })
                .onSuccess({ (users) in
                    self.users = users?.items ?? []
                })
                .onError({ (error) in
                    print("Error: \(error)")
                })
                .onCompletion({
                    self.tableView.reloadData()
                    print("Hide loading here")
                })
                .call()
```
More & more great features waiting to be explored.
### Thank you for reading!


