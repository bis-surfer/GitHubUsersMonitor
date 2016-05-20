//
//  UserCell.swift
//  GithubUsersMonitor
//
//  Created by Ilya Borisov on 5/10/16.
//  Copyright © 2016 TheLostWorld. All rights reserved.
//

import UIKit


class UserCell: UITableViewCell {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var profileLinkLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        let widthConstraint : NSLayoutConstraint = NSLayoutConstraint(item: self.avatarImageView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 50.0);
        
        let heightConstraint : NSLayoutConstraint = NSLayoutConstraint(item: self.avatarImageView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 50.0);
        
        self.avatarImageView.addConstraint(widthConstraint)
        self.avatarImageView.addConstraint(heightConstraint)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
