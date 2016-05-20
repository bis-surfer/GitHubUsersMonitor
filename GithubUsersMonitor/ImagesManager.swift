//
//  ImagesManager.swift
//  GithubUsersMonitor
//
//  Created by Ilya Borisov on 5/11/16.
//  Copyright © 2016 TheLostWorld. All rights reserved.
//

import UIKit

protocol ImagesDownloading {
    
    func didDownloadImageForRowAtIndexPath(indexPath: NSIndexPath)
}


class ImagesManager: NSObject {
    
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    
    lazy var downloadQueue: NSOperationQueue = {
        
        var queue = NSOperationQueue()
        
        queue.name = "Images Download Queue"
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    var downloadingDelegate : ImagesDownloading?
    
    
    func startDownloadForUser(user: User, indexPath: NSIndexPath) {
        
        if self.downloadsInProgress[indexPath] != nil {
            return
        }
        
        let downloadOperation = downloadImageOperation(user: user)
        
        downloadOperation.completionBlock = {
            
            if downloadOperation.cancelled {
                return
            }
            
            self.downloadsInProgress.removeValueForKey(indexPath)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.downloadingDelegate?.didDownloadImageForRowAtIndexPath(indexPath)
                
                if self.downloadsInProgress.count == 0 {
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            })
        }
        
        self.downloadsInProgress[indexPath] = downloadOperation
        
        self.downloadQueue.addOperation(downloadOperation)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
}


class downloadImageOperation: NSOperation {
    
    let user : User!
    
    init(user: User!) {
        
        self.user = user
        
        super.init()
    }
    
    override func main() {
        
        if self.cancelled {
            return
        }
        
        let imageUrl = NSURL(string: self.user.avatarUrl!)
        let imageData = NSData(contentsOfURL: imageUrl!)
        
        if self.cancelled {
            return
        }
        
        if imageData?.length > 0 {
            
            self.user.avatarImage = UIImage(data:imageData!)
        }
        else {
            
            self.user.avatarImage = UIImage(named: "Failed")
        }
    }
}
