//
//  FooterView.swift
//  GithubUsersMonitor
//
//  Created by Ilya Borisov on 5/12/16.
//  Copyright © 2016 TheLostWorld. All rights reserved.
//

import UIKit


class FooterView: UIView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func showActivityIndicator () {
        
        self.activityIndicator.alpha = 1.0;
        
        if (!self.activityIndicator.isAnimating()) {
            
            self.activityIndicator.startAnimating();
        }
    }
    
    func hideActivityIndicator () {
        
        self.activityIndicator.alpha = 0.0;
        
        if (self.activityIndicator.isAnimating()) {
            
            self.activityIndicator.stopAnimating();
        }
    }
}
