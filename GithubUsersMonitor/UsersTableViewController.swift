//
//  UsersTableViewController.swift
//  GithubUsersMonitor
//
//  Created by Ilya Borisov on 4/20/16.
//  Copyright © 2016 TheLostWorld. All rights reserved.
//

import UIKit


class UsersTableViewController: UITableViewController, ImagesDownloading {
    
    @IBOutlet weak var footerView: FooterView!
    
    var userDetailsViewController: UserDetailsViewController? = nil
    
    var usersManager: UsersManager? = nil
    var users: Array<User> = []
    var isRequestingNewUsers: Bool = false
    
    let imagesManager = ImagesManager()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.usersManager = UsersManager()
        self.requestMoreUsers()
        
        if let split = self.splitViewController {
            
            let controllers = split.viewControllers
            self.userDetailsViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? UserDetailsViewController
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didObtainUsersUpdatedNotification", name: users_updated_notification_name, object: nil)
        
        self.imagesManager.downloadingDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Requesting and handling JSON data about GitHub users
    
    func requestMoreUsers() {
        
        self.usersManager!.requestUsers()
        self.isRequestingNewUsers = true
        // self.tableView.reloadData()
    }
    
    func didObtainUsersUpdatedNotification() {
        
        self.isRequestingNewUsers = false
        self.users = (usersManager?.users)!
        self.tableView.reloadData()
    }
    
    // MARK: - ImagesDownloading protocol method(s)
    
    func didDownloadImageForRowAtIndexPath(indexPath: NSIndexPath) {
        
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let user = self.users[indexPath.row]
                let userDetailsViewController = (segue.destinationViewController as! UINavigationController).topViewController as! UserDetailsViewController
                userDetailsViewController.user = user
                userDetailsViewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                userDetailsViewController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - UITableViewDataSource protocol method(s)
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        
        let user = users[indexPath.row] as User
        
        cell.loginLabel!.text = user.login
        
        cell.profileLinkLabel?.text = user.profileLink
        
        cell.avatarImageView?.image = user.avatarImage != nil ? user.avatarImage : UIImage(named: "Placeholder")
        
        if (user.avatarImage != nil) {
            
            if cell.accessoryView != nil {
                
                let indicator = cell.accessoryView as! UIActivityIndicatorView
                
                indicator.stopAnimating()
                
                cell.accessoryView = nil
            }
        }
        else {
            
            if cell.accessoryView == nil {
                
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                cell.accessoryView = indicator
            }
            let indicator = cell.accessoryView as! UIActivityIndicatorView
            
            indicator.startAnimating()
            
            self.imagesManager.startDownloadForUser(user, indexPath: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate protocol method(s)
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return self.footerView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.isRequestingNewUsers {
            
            self.footerView.showActivityIndicator()
            
            return self.tableView.sectionFooterHeight;
        }
        
        self.footerView.hideActivityIndicator()
        
        return 0.0;
    }
    
    // MARK: - UIScrollViewDelegate protocol method(s)
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!scrollView.dragging) {
            return;
        }
        
        if (self.isRequestingNewUsers) {
            return;
        }
        
        let leadOffset = self.tableView.rowHeight;
        
        let contentIndent = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (contentIndent > leadOffset && scrollView.contentOffset.y + leadOffset > contentIndent) {
            
            self.requestMoreUsers()
        }
    }
}

