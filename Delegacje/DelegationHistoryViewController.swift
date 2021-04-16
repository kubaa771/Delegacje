//
//  DelegationHistoryViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 22/12/2020.
//

import UIKit
import FirebaseAuth

class DelegationHistoryViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    
    var delegations: [Delegation] = []
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationBar()
        tableView.dataSource = self
        tableView.delegate = self
        getUserData()
    }
    
    func updateNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = view.backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = true
        
        let delegacjeLabel = UILabel()
        delegacjeLabel.text = "Historia delegacji"
        delegacjeLabel.font = UIFont(name: "Verdana-Bold", size: 25.0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: delegacjeLabel)

    }
    
    func getUserData() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        FirebaseConnections.shared.getUserData(userId: currentUserId) { (user) in
            self.currentUser = user
            self.getHistoryDelegations()
        }
    }
    
    func getHistoryDelegations() {
        FirebaseConnections.shared.getHistoryDelegations(currentUserId: currentUser.id) { (delegations) in
            self.delegations = delegations
            self.tableView.reloadData()
        }
    }
    

}

extension DelegationHistoryViewController: UITableViewDelegate, UITableViewDataSource {
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
