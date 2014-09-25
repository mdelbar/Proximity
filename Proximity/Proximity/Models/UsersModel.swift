//
//  UsersModel.swift
//  Proximity
//
//  Created by Matthias Delbar on 25/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation

class UsersModel: Model {
    
    var me = User()
    var users: [User] = []
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserverForName("AllUsersFetched", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleAllUsersFetchedNotification)
    }
    
    // MARK: - Notification handlers
    
    func handleAllUsersFetchedNotification(notification: NSNotification!) {
        logger.verbose("Handling notification [\(notification.name)]")
        
        if let data: NSDictionary = unwrapNotificationData(notification: notification) {
            // Since all users were fetched, just clear the list and add from scratch
            self.users.removeAll(keepCapacity: false)
            
            if let users = data["users"] as? NSArray {
                for user: NSDictionary in users as [NSDictionary] {
                    var newUser = User()
                    if let name = user["name"] as? String {
                        newUser.name = name
                    }
                    if let age = user["age"] as? Int {
                        newUser.age = age
                    }
                    if let lat = user["lat"] as? Double {
                        if let long = user["long"] as? Double {
                            newUser.location = (lat, long)
                        }
                    }
                    self.users.append(newUser)
                }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("UsersModelUpdated", object: nil)
        }
    }
    
}