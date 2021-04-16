//
//  MainCoordinator.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 20/12/2020.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.isTranslucent = true
    }
    
    func start() {
        let vc = LoginViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func createNewAccount() {
        let vc = RegisterViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openTabBar() {
        let coord = TabCoordinator(navigationController: navigationController)
        navigationController.viewControllers.remove(at: 0)
        coord.start()
    }
    
}
