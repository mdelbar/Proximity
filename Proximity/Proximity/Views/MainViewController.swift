//
//  MainViewController.swift
//  Proximity
//
//  Created by Matthias Delbar on 24/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class MainViewController: UIViewController {
    
    let mainViewToMapViewSegueIdentifier = "mainViewToMapViewSegue"
    var usersModel = UsersModel()
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var sexSC: UISegmentedControl!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var lookingForSexSC: UISegmentedControl!
    @IBOutlet weak var lookingForAgeMinTF: UITextField!
    @IBOutlet weak var lookingForAgeMaxTF: UITextField!
    
    
    @IBAction func search(sender: AnyObject) {
        let searchBtn = sender as UIBarButtonItem
        searchBtn.enabled = false
        if(validateFields()) {
            searchBtn.enabled = true
            goToMapView()
        }
        // Re-enable the search button regardless if we go to map view or not
        searchBtn.enabled = true
    }
    
    private func validateFields() -> Bool {
        var valid = true
        
        var textFields = [nameTF, ageTF, lookingForAgeMinTF, lookingForAgeMaxTF]
        var segments = [sexSC, lookingForSexSC]
        
        // Reset colors
        for textfield in textFields {
            textfield.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
        for segment in segments {
            segment.tintColor = UIColor(red: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        }
        
        // Validate everything
        for tf in textFields {
            if(tf.text == nil || tf.text.isEmpty) {
                valid = false
                tf.layer.borderColor = UIColor.redColor().CGColor
                tf.layer.borderWidth = 1.0
                tf.layer.cornerRadius = 5
                tf.clipsToBounds = true
            }
        }
        for seg in segments {
            if(seg.selectedSegmentIndex == -1) {
                valid = false
                seg.tintColor = UIColor.redColor()
            }
        }
        
        return valid
    }
    
    private func goToMapView() {
        if usersModel.me.id == nil {
            // ID is nil, so user has not yet been created on the server
            var sex: String
            switch sexSC.selectedSegmentIndex {
                case 0:
                    sex = "m"
                case 1:
                    sex = "f"
                default:
                    sex = ""
            }
            
            var lookingForSex: String
            switch lookingForSexSC.selectedSegmentIndex {
                case 0:
                    lookingForSex = "m"
                case 1:
                    lookingForSex = "f"
                case 2:
                    lookingForSex = "m,f"
                default:
                    lookingForSex = ""
            }
            
            NSNotificationCenter.defaultCenter().addObserverForName("UserCreated", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: handleUserCreatedNotification)
            UserController().createUser(name: nameTF.text, age: ageTF.text.toInt()!, sex: sex, lat: 0.0, long: 0.0, lookingFor: lookingForSex)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == mainViewToMapViewSegueIdentifier) {
            let destination = segue.destinationViewController as MapViewController
            destination.usersModel = usersModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Notification handlers
    
    func handleUserCreatedNotification(notification: NSNotification!) {
        logger.verbose("Handling notification [\(notification.name)]")
        
        self.performSegueWithIdentifier(mainViewToMapViewSegueIdentifier, sender: self)
    }
}