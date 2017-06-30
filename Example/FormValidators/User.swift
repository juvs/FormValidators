//
//  User.swift
//  FormValidators
//
//  Created by Juvenal Guzman on 6/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

class User {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var city: City?
}

class City {
    var id: Int?
    var name: String = ""
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
