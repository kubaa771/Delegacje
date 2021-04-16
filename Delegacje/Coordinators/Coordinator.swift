//
//  Coordinator.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 20/12/2020.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController {get set}
    
    func start()
}
