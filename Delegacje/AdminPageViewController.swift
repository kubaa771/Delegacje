//
//  AdminPageViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 17/02/2021.
//

import Foundation
import UIKit

class AdminPageViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var allDelegationsButton: UIButton!
    @IBOutlet weak var employeesButton: UIButton!
    @IBOutlet weak var raportButton: UIButton!
    
    weak var coordinator: AdminCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationBar()
        setupButtons()
    }
    
    func updateNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = view.backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = true
        
        let label = UILabel()
        label.text = "Strona admina"
        label.font = UIFont(name: "Verdana-Bold", size: 25.0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
    }
    
    func setupButtons(){
        allDelegationsButton.layer.cornerRadius = 30
        employeesButton.layer.cornerRadius = 30
        raportButton.layer.cornerRadius = 30
    }
    
    @IBAction func allDelegationsButtonTapped(_ sender: UIButton) {
        coordinator?.openAllDelegationsViewController()
    }
    
    @IBAction func employeesButtonTapped(_ sender: UIButton) {
        coordinator?.openEmployeesViewController()
    }
    
    @IBAction func raportButtonTapped(_ sender: UIButton) {
        coordinator?.openRaportViewController()
    }
    
}
