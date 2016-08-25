# IDMCore

[![CI Status](http://img.shields.io/travis/Nguyen Chi Cong/IDMCore.svg?style=flat)](https://travis-ci.org/Nguyen Chi Cong/IDMCore)
[![Version](https://img.shields.io/cocoapods/v/IDMCore.svg?style=flat)](http://cocoapods.org/pods/IDMCore)
[![License](https://img.shields.io/cocoapods/l/IDMCore.svg?style=flat)](http://cocoapods.org/pods/IDMCore)
[![Platform](https://img.shields.io/cocoapods/p/IDMCore.svg?style=flat)](http://cocoapods.org/pods/IDMCore)

## Installation

IDMCore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IDMCore"
```

## Author

Nguyen Chi Cong, congncif@gmail.com

## License

IDMCore is available under the MIT license. See the LICENSE file for more info.

## Example ##
http://github.com/congncif/IDM-Data-Flow  
This is a sample which conforms IDM Data Flow.

### What is IDM Data Flow? ###

In MVC application, your view controllers have to working with a lot of data from local, network, ... This causes you much trouble & becomes difficult to manage. Conform IDM Flow will help you make data flow clearer.  
IDM ~ Integration - Data - Model, they are three layers of this flow.  
All models will be defined in Model Layer. Working with Data logic (get, submit, save, ...) is DataLayer's responsible. Two these layers is independence with other.  
Creating & executing a flow is responsibility of Integration Layer. A Integration layer will call to data layer & return model in completion.  

### How do I get set up? ###

Add ```pod 'IDMCore'``` to Podfile. Run ```pod install``` to setup IDM for project.

### Usage ###

#### Model Layer  

* Create a model conforms ModelProtocol, which can initialize from dictionary:

```swift
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
```

* For response model:

```swift
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
```

#### Data Layer

* Create DataLayer conforms DataProtocol. It get data with parameters & return a dictionary.

```swift
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
```

#### Integration Layer

* A integration controller will be declared to execute a data flow. A data flow will do a single responsibility. Integration conforms IntegrationProtocol.
You also can use default integration generic classes that built for using easily.

```swift
public class UserIntegration: DefaultIntegration<UserData, Users> {
    public required init(){}
}
```

#### Execute

* Using Binding:

Custom UI
```swift
extension UIView: CanPresentLoadingView {
    public func presentLoadingView() {
        MBProgressHUD.showHUDAddedTo(self, animated: true)
        print("loading...")
    }
    
    public func dismissLoadingView() {
        MBProgressHUD.hideHUDForView(self, animated: true)
        print("dimiss")
    }
}

extension UIViewController : CanPresentErrorAlert {
    public func presentErrorAlert(error: NSError?) {
        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
```

Create an adapter to handle display data source
```swift
class UsersDataAdapter: DefaultDataBinding<Users>, UITableViewDataSource {
    
    weak var tableView: UITableView? {
        didSet {
            self.tableView?.dataSource = self
        }
    }
    var users:[User] = []
    
    required init() {}
    
    override func bindingData(parameters: [String : AnyObject]?, data: Users?) {
        print(data?.items?.count)
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
```

In ViewController:
```swift
    defaultIntegration.execute(loadingPresenter: self.view, errorAlertPresenter: self, dataBinding: self.adapter)
```

* Use Integration Call:
```swift
        defaultIntegration.prepareCall().onBeginning({
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            }).onSuccess({ (users) in
                self.users = users?.items ?? []
                self.tableView.reloadData()
            }).onError({ (error) in
                print("Error: \(error)")
            }).onCompletion({ 
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }).call()
```

All done.  

* By using IDM, you can change data layer obeject or model object very easily by redefining Integration object. Example:  
```UserIntegration: DefaultIntegration<UserData, Users>```  
```UserIntegration: DefaultIntegration<OtherDataLayer, OtherModel>```  

* Using ```CompoundDataLayer``` if you want compound multiple data layer together  

* And more cool feature...Enjoy it!!!   

Thank you for reading!
