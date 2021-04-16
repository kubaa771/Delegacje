//
//  User.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 13/02/2021.
//

import Foundation

class User {
    var id: String
    var fullName: String
    var email: String
    var numberOfDelegations: Int?
    
    init(id: String, fullName: String, email: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
    }
}
