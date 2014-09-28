//
//  UserController.swift
//  Proximity
//
//  Created by Matthias Delbar on 24/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation

class UserController {
    
    func fetchUsersNear(#user: User) {
        if let userId = user.id {
            HttpHelper.get(serverPath: "/users_near/\(userId)", notification: "AllUsersFetched")
        }
    }
    
    func createUser(#name: String, age: Int, sex: String, lat: Double?, long: Double?, lookingFor: String) {
        let userData = ["name": name, "age": age, "sex": sex, "lat": lat!, "long": long!, "looking_for": lookingFor]
        HttpHelper.post(serverPath: "/users", data: userData, notification: "UserCreated")
    }
    
    func updateUser(#user: User) {
        if let userId = user.id {
            let userData = user.toDictionary()
            HttpHelper.put(serverPath: "/users/\(userId)", data: userData, notification: "UserUpdated")
        }
    }
    
}