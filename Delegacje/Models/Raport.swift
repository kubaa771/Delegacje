//
//  Raport.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 02/03/2021.
//

import Foundation

class Raport {
    var fromDate: Date
    var toDate: Date
    var numberOfDelegations: Int
    var totalDistance: Float
    var totalPrice: Float
    var averageDistance: Float
    var maxDistance: Float
    var minDistance: Float
    
    init(fromDate: Date, toDate: Date, numberOfDelegations: Int, totalDistance: Float, totalPrice: Float, averageDistance: Float, maxDistance: Float, minDistance: Float) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.numberOfDelegations = numberOfDelegations
        self.totalDistance = totalDistance
        self.totalPrice = totalPrice
        self.averageDistance = averageDistance
        self.maxDistance = maxDistance
        self.minDistance = minDistance
    }
}
