//
//  AddNewDelegationViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 23/12/2020.
//

import UIKit

class AddNewDelegationViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var departureDatePicker: UIDatePicker!
    @IBOutlet weak var arrivalDatePicker: UIDatePicker!
    @IBOutlet weak var availableCarsPickerView: UIPickerView!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var departurePlaceTextField: UITextField!
    @IBOutlet weak var arrivalPlaceTextField: UITextField!
    
    weak var coordinator: HomeCoordinator?
    var currentUser: User!
    
    var availableCars: [Car] = []
    var selectedCar: Car?

    override func viewDidLoad() {
        super.viewDidLoad()
        availableCarsPickerView.delegate = self
        availableCarsPickerView.dataSource = self
        getPickerData()
        changeDates()
    }
    
    func getPickerData() {
        //TODO: Zrobić skrypt getAvailableCars
        FirebaseConnections.shared.getAvailableCars { [self] (cars) in
            guard let cars = cars else { return }
            self.availableCars = cars
            self.availableCarsPickerView.reloadAllComponents()
            selectedCar = availableCars[0]
        }
    }
    
    func changeDates() {
        //TODO: Change date range in datepickers
        departureDatePicker.minimumDate = Date()
        arrivalDatePicker.minimumDate = Date()
    }
    
    
    @IBAction func addNewDelegationButtonAction(_ sender: UIButton) {
        guard let distance = distanceTextField.text, let departurePlace = departurePlaceTextField.text, let arrivalPlace = arrivalPlaceTextField.text, let car = selectedCar else {
            self.showAlert(title: "Error", message: "Please fill all of the fields above..")
        return }
        
        guard let distanceFloat = Float(distance) else {
            self.showAlert(title: "Error", message: "Please provide right value for distance! (f.e 140)")
        return }
        
        let departureDate = departureDatePicker.date
        let arrivalDate = arrivalDatePicker.date

        FirebaseConnections.shared.addNewDelegation(userId: currentUser.id, departureDate: departureDate, arrivalDate: arrivalDate, car: car, distance: distanceFloat, departurePlace: departurePlace, arrivalPlace: arrivalPlace) { (success) in
            if success == false {
                self.showAlert(title: "Error", message: "Something went wrong while adding new delegation..")
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
}

extension AddNewDelegationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableCars.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableCars[row].brand + " " + availableCars[row].model
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCar = availableCars[row]
    }
    
}
