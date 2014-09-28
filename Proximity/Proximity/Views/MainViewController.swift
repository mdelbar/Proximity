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
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var sexSC: UISegmentedControl!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var lookingForSexSC: UISegmentedControl!
    @IBOutlet weak var lookingForAgeMinTF: UITextField!
    @IBOutlet weak var lookingForAgeMaxTF: UITextField!
    
    var mapViewController: MapViewController?
    
    
    @IBAction func search(sender: AnyObject) {
        if(validateFields()) {
            goToMapView()
        }
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
            segment.tintColor = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
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
        logger.debug("Going to map view")
        self.performSegueWithIdentifier("mainViewToMapViewSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}