//
//  RaportViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 28/02/2021.
//

import UIKit

class RaportViewController: UIViewController, Storyboarded {
    
    weak var coordinator: AdminCoordinator?
    @IBOutlet weak var datesPickerView: DatesPickerView!
    var raport: Raport?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButtons()
        initializePopup()
    }
    
    func setupNavigationButtons() {
        self.navigationController?.navigationBar.backgroundColor = view.backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = true
    
        let employeesLabel = UILabel()
        employeesLabel.text = "Raport"
        employeesLabel.font = UIFont(name: "Verdana-Bold", size: 25.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: employeesLabel)
    }
    
    func initializePopup() {
        self.view.backgroundColor = UIColor.systemGray6
        datesPickerView.tappedClosure = doneButtonTapped
        
        let contactRect = CGRect(x: -20, y: datesPickerView.bounds.height - (20 * 0.4), width: datesPickerView.bounds.width + 20 * 2, height: 20)
        datesPickerView.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        datesPickerView.layer.shadowRadius = 5
        datesPickerView.layer.shadowOpacity = 0.4
        
        datesPickerView.layer.cornerRadius = 25
        view.layoutSubviews()
    }
    
    func doneButtonTapped() {
        removePopup()
    }
    
    func removePopup() {
        UIView.animate(withDuration: 1) {
            self.datesPickerView.alpha = 0
        } completion: { (done) in
            self.datesPickerView.removeFromSuperview()
            self.loadRaport(firstDate: self.datesPickerView.firstDatePicker.date, secondDate: self.datesPickerView.secondDatePicker.date)
        }

    }
    
    func loadRaport(firstDate: Date, secondDate: Date) {
        FirebaseConnections.shared.getRaportFromDates(firstDate: firstDate, secondDate: secondDate) { (raportData) in
            self.raport = raportData
            self.createRaportView(raport: raportData)
        }
    }
    
    func createRaportView(raport: Raport) {
        //TODO: stworzyc labele constrainty stackview itp.
        
        //Label dat
        let datesLabel = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        datesLabel.text = dateFormatter.string(from: raport.fromDate) + " - " + dateFormatter.string(from: raport.toDate)
        datesLabel.translatesAutoresizingMaskIntoConstraints = false
        datesLabel.font = UIFont(name: "Verdana-Bold", size: 23)
        
        //Pozostale labele do stackview
        let numberOfDelegationsLabel = UILabel()
        numberOfDelegationsLabel.text = "Liczba delegacji: " + String(raport.numberOfDelegations)
        numberOfDelegationsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfDelegationsLabel.font = UIFont(name: "Verdana", size: 18)
        
        let totalDistanceLabel = UILabel()
        totalDistanceLabel.text = "Łączny dystans: " + String(raport.totalDistance) + "km"
        totalDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalDistanceLabel.font = UIFont(name: "Verdana", size: 18)
        
        let totalPriceLabel = UILabel()
        totalPriceLabel.text = "Łączna kwota: " + String(raport.totalPrice) + "zł"
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.font = UIFont(name: "Verdana", size: 18)
        
        let averageDistanceLabel = UILabel()
        averageDistanceLabel.text = "Średni dystans: " + String(raport.averageDistance) + "km"
        averageDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        averageDistanceLabel.font = UIFont(name: "Verdana", size: 18)
        
        let maxDistanceLabel = UILabel()
        maxDistanceLabel.text = "Największy dystans: " + String(raport.maxDistance) + "km"
        maxDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        maxDistanceLabel.font = UIFont(name: "Verdana", size: 18)
        
        let minDistanceLabel = UILabel()
        minDistanceLabel.text = "Najmniejszy dystans: " + String(raport.minDistance) + "km"
        minDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        minDistanceLabel.font = UIFont(name: "Verdana", size: 18)
        
        //STACKVIEW
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15.0
        
        stackView.addArrangedSubview(numberOfDelegationsLabel)
        stackView.addArrangedSubview(totalDistanceLabel)
        stackView.addArrangedSubview(totalPriceLabel)
        stackView.addArrangedSubview(averageDistanceLabel)
        stackView.addArrangedSubview(maxDistanceLabel)
        stackView.addArrangedSubview(minDistanceLabel)
        
        self.view.addSubview(datesLabel)
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            datesLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            datesLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 50)
        ])
        
        view.layoutSubviews()
    }
    
}
