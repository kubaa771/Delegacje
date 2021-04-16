//
//  AllDelegationsViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 20/02/2021.
//

import UIKit

class AllDelegationsViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: AdminCoordinator?
    var delegations: [Delegation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavigationButtons()
        getAllDelegations()
    }
    
    func setupNavigationButtons() {
        self.navigationController?.navigationBar.backgroundColor = view.backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = true
    
        let delegationsLabel = UILabel()
        delegationsLabel.text = "Wszystkie delegacje"
        delegationsLabel.font = UIFont(name: "Verdana-Bold", size: 25.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: delegationsLabel)
    }
    
    func getAllDelegations() {
        FirebaseConnections.shared.getAllDelegations { (delegations) in
            self.delegations = delegations
            self.tableView.reloadData()
        }
    }


}

extension AllDelegationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DelegationTableViewCell", for: indexPath) as! DelegationTableViewCell
        cell.model = delegations[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
    
    
}
