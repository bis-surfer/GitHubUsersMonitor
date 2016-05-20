//
//  UserDetailsViewController.swift
//  GithubUsersMonitor
//
//  Created by Ilya Borisov on 4/20/16.
//  Copyright © 2016 TheLostWorld. All rights reserved.
//

import UIKit


class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var profileLinkLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    var user: User? {
        
        didSet {
            
            self.configureView()
        }
    }
    
    func configureView() {
        
        if (!self.isViewLoaded()) {
            
            return
        }
        
        if let user = self.user {
            
            self.loginLabel.text = user.login
            self.profileLinkLabel.text = user.profileLink
            self.avatarImageView.image = user.avatarImage
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureView()
        
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didObtainImageDownloadedNotification", name: image_downloaded_notification_name, object: nil)
*/
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notifications handling
    
    /*
    func didObtainImageDownloadedNotification() {
        
        self.configureView()
    }
*/
}

