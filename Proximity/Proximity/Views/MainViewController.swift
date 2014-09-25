//
//  MainViewController.swift
//  Proximity
//
//  Created by Matthias Delbar on 24/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    
    @IBAction func search(sender: AnyObject) {
        logger.debug("Going to map view!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}