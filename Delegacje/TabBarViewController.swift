//
//  TabBarViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 21/12/2020.
//

import UIKit

class TabBarViewController: UITabBarController, Storyboarded {
    
   var coordinator: TabCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    

}
