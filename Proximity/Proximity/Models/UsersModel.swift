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
        NSNotificationCenter.defaultCenter().addObserverForName("MyLocationUpdated", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleMyLocationUpdatedNotification)
        NSNotificationCenter.defaultCenter().addObserverForName("AllUsersFetched", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleAllUsersFetchedNotification)
        NSNotificationCenter.defaultCenter().addObserverForName("UserCreated", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleUserCreatedNotification)
    }
    
    // MARK: - Notification handlers
    
    func handleUserCreatedNotification(notification: NSNotification!) {
        logger.verbose("Handling notification [\(notification.name)]")
        
        if let data: NSDictionary = unwrapNotificationData(notification: notification) {
            logger.debug("User created: [\(data)]")
            if let user: NSDictionary = data["user"] as? NSDictionary {
                logger.debug("Updating user")
                me.id = user["id"] as? Int
                me.name = user["name"] as? String
                me.age = user["age"] as? Int
                me.sex = user["sex"] as? String
                me.lookingFor = user["looking_for"] as? String
                me.lat = user["lat"] as? Double
                me.long = user["long"] as? Double
            }
        }
    }
    
    func handleMyLocationUpdatedNotification(notification: NSNotification!) {
        logger.verbose("Handling notification [\(notification.name)]")
        
        if let data: NSDictionary = unwrapNotificationData(notification: notification) {
            me.lat = data["lat"] as? Double
            me.long = data["long"] as? Double
            logger.debug("New location, updating user with lat [\(me.lat)], long [\(me.long)]")
            UserController().updateUser(user: me)
        }
        
    }
    
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
                        newUser.lat = lat
                    }
                    if let long = user["long"] as? Double {
                        newUser.long = long
                    }
                    self.users.append(newUser)
                }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("UsersModelUpdated", object: nil)
        }
    }
    
}