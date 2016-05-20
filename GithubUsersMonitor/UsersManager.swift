//
//  UsersManager.swift
//  GithubUsersMonitor
//
//  Created by Ilya Borisov on 4/20/16.
//  Copyright © 2016 TheLostWorld. All rights reserved.
//

import UIKit

let users_updated_notification_name = "users_updated_notification"
let image_downloaded_notification_name = "users_updated_notification"


class UsersManager: NSObject {
    
    var last_id: Int
    var users: Array<User>
    
    
    override init() {
        
        self.last_id = 0
        self.users = []
        
        super.init()
    }
    
    func requestUsers() {
        
        let usersPerRequest: Int = 30
        let url: String = "https://api.github.com/users?per_page=\(usersPerRequest)&since=\(self.last_id)"
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {
            
            (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            do {
                
                let json_response = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                
                // process json_response
                for user_dictionary in json_response {
                    
                    let user = User(dictionary: user_dictionary as! NSDictionary)
                    
                    self.users.append(user)
                    
                    self.last_id = user.id
                }
                
                let lastUser: User = self.users.last!
                self.last_id = lastUser.id
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(users_updated_notification_name, object: self)
                })
                
            } catch let error as NSError {
                
                print("Failed to load: \(error.localizedDescription)")
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        })
    }
}
