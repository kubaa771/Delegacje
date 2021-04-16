//
//  CarsViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 21/12/2020.
//

import UIKit

class CarsViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    weak var coordinator: CarsCoordinator?
    var cars: [Car] = []
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRefreshControl()
        tableView.dataSource = self
        tableView.delegate = self
        setupNavigationButtons()
        getAllCars()
    }
    
    func setupNavigationButtons() {
        self.navigationController?.navigationBar.backgroundColor = view.backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = true
        
        let carsLabel = UILabel()
        carsLabel.text = "Wszystkie auta"
        carsLabel.font = UIFont(name: "Verdana-Bold", size: 25.0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: carsLabel)
        
        let addNewCarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewCar))
        navigationItem.rightBarButtonItem = addNewCarButtonItem
    }
    
    func updateRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(getAllCars), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func getAllCars() {
        FirebaseConnections.shared.getAllCars { (cars) in
            guard let cars = cars else { return }
            self.cars = cars
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func addNewCar() {
        coordinator?.addNewCar()
    }
    
}
extension CarsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: indexPath) as! CarsTableViewCell
        cell.model = cars[indexPath.row]
        return cell
    }
    
    
}
