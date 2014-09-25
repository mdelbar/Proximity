//
//  User.swift
//  Proximity
//
//  Created by Matthias Delbar on 25/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var age: Int?
    var location: (Double, Double)?
    
    init() {
        
    }
    
    // Read-only computed property
    var description: String! {
        get {
            return "User: name [\(name!)], age [\(age!)], location [\(location)]"
        }
    }
    
}