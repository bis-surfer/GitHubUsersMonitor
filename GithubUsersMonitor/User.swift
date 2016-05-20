//
//  User.swift
//  GithubUsersMonitor
//
//  Created by Ilya Borisov on 4/26/16.
//  Copyright © 2016 TheLostWorld. All rights reserved.
//

import UIKit

let id_key          = "id"
let login_key       = "login"
let profile_url_key = "html_url"
let avatar_url_key  = "avatar_url"


class User: NSObject, NSCoding {
    
    let id: Int
    var login: String!
    
    var profileLink: String?
    var avatarUrl: String?
    
    var avatarImage: UIImage?
    
    
    @objc required init(coder aDecoder: NSCoder) {
        
        self.id          = aDecoder.decodeObjectForKey(id_key)          as! Int
        self.login       = aDecoder.decodeObjectForKey(login_key)       as! String
        self.profileLink = aDecoder.decodeObjectForKey(profile_url_key) as? String
        self.avatarUrl   = aDecoder.decodeObjectForKey(avatar_url_key)  as? String
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.id,          forKey: id_key)
        aCoder.encodeObject(self.login,       forKey: login_key)
        aCoder.encodeObject(self.profileLink, forKey: profile_url_key)
        aCoder.encodeObject(self.avatarUrl,   forKey: avatar_url_key)
    }
    
    override init() {
        
        self.id = 0
        self.login = "none"
        
        super.init()
    }
    
    init(dictionary: NSDictionary ) {
        
        self.id          = dictionary[id_key]          as! Int
        self.login       = dictionary[login_key]       as! String
        self.profileLink = dictionary[profile_url_key] as? String
        self.avatarUrl   = dictionary[avatar_url_key]  as? String
        
        super.init()
    }
}
