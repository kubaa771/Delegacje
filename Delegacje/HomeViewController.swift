//
//  HomeViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 21/12/2020.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    weak var coordinator: HomeCoordinator?
    var delegations: [Delegation] = []
    var currentUser: User!
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationBar()
        updateCurrentDate()
        getUserData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func updateNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = view.backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = true
        
        let delegacjeLabel = UILabel()
        delegacjeLabel.text = "Obecne delegacje"
        delegacjeLabel.font = UIFont(name: "Verdana-Bold", size: 25.0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: delegacjeLabel)
        
        let addNewDelegationButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewDelegation))
        navigationItem.rightBarButtonItem = addNewDelegationButtonItem
    }
    
    func updateCurrentDate() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        currentDateLabel.text = "Dzisiaj: " + dateFormatter.string(from: currentDate)
    }
    
    func updateRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getCurrentDelegations), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func getUserData() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        FirebaseConnections.shared.getUserData(userId: currentUserId) { (user) in
            self.currentUser = user
            self.fullNameLabel.text = user.fullName
            self.updateRefreshControl()
            self.getCurrentDelegations()
        }
    }
    
    @objc func getCurrentDelegations() {
        FirebaseConnections.shared.getCurrentDelegations(currentUserId: currentUser.id) { [self] (delegations) in
            self.delegations = delegations
            tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    @objc func addNewDelegation() {
        guard let currentUser = currentUser else { return }
        coordinator?.addNewDelegation(currentUser: currentUser)
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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
