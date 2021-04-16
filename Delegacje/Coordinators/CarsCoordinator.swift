//
//  CarsCoordinator.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 22/12/2020.
//

import Foundation
import UIKit

class CarsCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = CarsViewController.instantiate()
        vc.coordinator = self
    }
    
    func addNewCar() {
        let vc = AddNewCarViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
