//
//  MapViewController.swift
//  Proximity
//
//  Created by Matthias Delbar on 24/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController {
    
    var locationController = LocationController()
    var userController = UserController()
    var usersModel = UsersModel()
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register for user model updates
        NSNotificationCenter.defaultCenter().addObserverForName("UsersModelUpdated", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleUserModelUpdatedNotification)
        
        // Register for location updates and start tracking location
        NSNotificationCenter.defaultCenter().addObserverForName("MyLocationUpdated", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleMyLocationUpdatedNotification)
        locationController.startTrackingLocation()
    }
    
    
    // MARK: - Notification handlers
    
    func handleMyLocationUpdatedNotification(notification: NSNotification!) {
        logger.verbose("Handling notification [\(notification.name)]")
        
        // Remove self as observer again
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "MyLocationUpdated", object: nil)
        
        // Fetch users from server
        userController.fetchUsers()
    }
    
    func handleUserModelUpdatedNotification(notification: NSNotification!) {
        logger.verbose("Handling notification [\(notification.name)]")
        logger.debug("Users model was updated, refreshing view")
        
        // Refresh view
        textView.text = ""
        for user in usersModel.users {
            textView.text = textView.text + "\n" + user.description
        }
    }
}