//
//  AdminCoordinator.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 19/02/2021.
//

import Foundation
import UIKit

class AdminCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AdminPageViewController.instantiate()
        vc.coordinator = self
    }
    
    func openEmployeesViewController() {
        let vc = EmployeesViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openAllDelegationsViewController() {
        let vc = AllDelegationsViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openRaportViewController() {
        let vc = RaportViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
