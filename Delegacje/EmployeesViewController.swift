//
//  EmployeesViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 20/02/2021.
//

import UIKit

class EmployeesViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: AdminCoordinator?
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavigationButtons()
        getAllUsers()
    }
    
    func setupNavigationButtons() {
        self.navigationController?.navigationBar.backgroundColor = view.backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = true
    
        let employeesLabel = UILabel()
        employeesLabel.text = "Wszyscy pracownicy"
        employeesLabel.font = UIFont(name: "Verdana-Bold", size: 25.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: employeesLabel)
    }
    
    func getAllUsers() {
        FirebaseConnections.shared.getAllUsers { (users) in
            self.users = users
            self.tableView.reloadData()
        }
    }
    

}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeesTableViewCell", for: indexPath) as! EmployeesTableViewCell
        cell.model = users[indexPath.row]
        return cell
    }
    
    
}
