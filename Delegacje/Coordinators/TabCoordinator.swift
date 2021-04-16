//
//  TabCoordinator.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 21/12/2020.
//

import Foundation
import UIKit

class TabCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarVc = TabBarViewController()
        tabBarVc.coordinator = self
        var controllers: [UIViewController] = []
        
        //TODO: Dodać HomeCoordinator i HistoryCoordinator?
        
        let homeVc = HomeViewController.instantiate()
        homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let homeVcNv = UINavigationController(rootViewController: homeVc)
        let homeCoordinator = HomeCoordinator(navigationController: homeVcNv)
        homeVc.coordinator = homeCoordinator
        childCoordinators.append(homeCoordinator)
        
        let historyVc = DelegationHistoryViewController.instantiate()
        historyVc.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        let historyVcNv = UINavigationController(rootViewController: historyVc)
        //history coordinator
        
        let carsVc = CarsViewController.instantiate()
        carsVc.tabBarItem = UITabBarItem(title: "Cars", image: UIImage(systemName: "car"), selectedImage: UIImage(systemName: "car.fill"))
        let carsVcNv = UINavigationController(rootViewController: carsVc)
        let carsCoordinator = CarsCoordinator(navigationController: carsVcNv)
        carsVc.coordinator = carsCoordinator
        childCoordinators.append(carsCoordinator)
        
        controllers.append(homeVcNv)
        controllers.append(historyVcNv)
        controllers.append(carsVcNv)
        
        let checker = FirebaseConnections.shared.checkIfCurrentUserIsAdmin()
        if checker {
            let adminVc = AdminPageViewController.instantiate()
            adminVc.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
            let adminVcNv = UINavigationController(rootViewController: adminVc)
            let adminCoordinator = AdminCoordinator(navigationController: adminVcNv)
            adminVc.coordinator = adminCoordinator
            childCoordinators.append(adminCoordinator)
            controllers.append(adminVcNv)
        }
        
        
        tabBarVc.viewControllers = controllers
        tabBarVc.tabBar.isTranslucent = false
        
        navigationController.navigationBar.isHidden = true
        
        
        //navigationController.setViewControllers([tabBarVc], animated: true) //zmienic na cars?
        navigationController.pushViewController(tabBarVc, animated: true)
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
}
