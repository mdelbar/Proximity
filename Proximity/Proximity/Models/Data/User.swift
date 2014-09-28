//
//  User.swift
//  Proximity
//
//  Created by Matthias Delbar on 25/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation

class User {
    
    var id: Int?
    var name: String?
    var age: Int?
    var sex: String?
    // Comma-separated string
    var lookingFor: String?
    var lat: Double?
    var long: Double?
    
    init() {
        
    }
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        var dict: Dictionary<String, AnyObject> = [:]
        if id != nil {
            dict["id"] = id as Int!
        }
        if name != nil {
            dict["name"] = name as String!
        }
        if age != nil {
            dict["age"] = age as Int!
        }
        if sex != nil {
            dict["sex"] = sex as String!
        }
        if lookingFor != nil {
            dict["looking_for"] = lookingFor as String!
        }
        if lat != nil {
            dict["lat"] = lat as Double!
        }
        if long != nil {
            dict["long"] = long as Double!
        }
        
        return dict
    }
    
    // Read-only computed property
    var description: String! {
        get {
            return toDictionary().description
        }
    }
    
}