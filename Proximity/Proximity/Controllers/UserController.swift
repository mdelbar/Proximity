//
//  UserController.swift
//  Proximity
//
//  Created by Matthias Delbar on 24/09/14.
//  Copyright (c) 2014 Matthias Delbar. All rights reserved.
//

import Foundation

class UserController {
    
    func fetchUsers() {
        HttpHelper.get(serverPath: "/users", notification: "AllUsersFetched")
    }
    
}