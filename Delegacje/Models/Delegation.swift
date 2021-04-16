//
//  Delegation.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 21/01/2021.
//

import Foundation

class Delegation {
    var departureDate: Date
    var arrivalDate: Date
    var car: Car?//TODO: Car czy CarID?
    var distance: Float
    var departurePlace: String
    var arrivalPlace: String
    var user: User?
    //var userID: String albo userEmail
    
    init(departureDate: Date, arrivalDate: Date, distance: Float, departurePlace: String, arrivalPlace: String) {
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.distance = distance
        self.departurePlace = departurePlace
        self.arrivalPlace = arrivalPlace
    }
    
}
