//
//  HomeCoordinator.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 29/12/2020.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
    }
    
    func addNewDelegation(currentUser: User) {
        let vc = AddNewDelegationViewController.instantiate()
        vc.coordinator = self
        vc.currentUser = currentUser
        navigationController.pushViewController(vc, animated: true)
    }
    
}
