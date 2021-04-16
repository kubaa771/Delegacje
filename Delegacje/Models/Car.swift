//
//  Car.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 06/01/2021.
//

import Foundation

class Car {
    var id: String
    var brand: String
    var model: String
    var capacity: Float
    var productionYear: Int
    var ryczalt: Float
    var stawka: Float
    var inUse: Bool?
    
    init(id: String, brand: String, model: String, capacity: Float, productionYear: Int, ryczalt: Float, stawka: Float) {
        self.id = id
        self.brand = brand
        self.model = model
        self.capacity = capacity
        self.productionYear = productionYear
        self.ryczalt = ryczalt
        self.stawka = stawka
    }
}
