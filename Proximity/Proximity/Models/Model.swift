//
//  Model.swift
//  Proximity
//
//  Created by Matthias Delbar on 25/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation

class Model {
    
    // Helper function for unwrapping notification data
    func unwrapNotificationData(#notification: NSNotification!) -> NSDictionary? {
        if(notification == nil) {
            logger.error("Notification is NIL")
            return nil
        }
        
        if(notification.userInfo == nil) {
            logger.error("No data found in notification: [\(notification)]")
            return nil
        }
        
        var data: NSDictionary! = notification.userInfo! as NSDictionary
        
        logger.verbose("Unwrapping notification data: [\(data)]")
        return data
    }

}