//
//  AddNewCarViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 22/12/2020.
//

import UIKit

class AddNewCarViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var carBrandTextField: UITextField!
    @IBOutlet weak var carModelTextField: UITextField!
    @IBOutlet weak var carCapacityTextField: UITextField!
    @IBOutlet weak var carProductionYearTextField: UITextField!
    @IBOutlet weak var carRyczaltTextField: UITextField!
    @IBOutlet weak var carStawkaTextField: UITextField!
    
    weak var coordinator: CarsCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkRightCapacityValue(_ sender: UITextField) {
        guard let capacityValue = Float(sender.text!) else {
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.1673969667, blue: 0.07801140196, alpha: 0.5059663955)
        return }
        
        if capacityValue > 0.1 && capacityValue < 20 {
            sender.backgroundColor = #colorLiteral(red: 0.04321000128, green: 1, blue: 0.05295898193, alpha: 0.5)
            if capacityValue < 1.4 {
                carRyczaltTextField.text = "0.85"
                carStawkaTextField.text = "0.90"
            } else if capacityValue >= 1.4 && capacityValue < 2.0 {
                carRyczaltTextField.text = "0.95"
                carStawkaTextField.text = "0.90"
            } else if capacityValue >= 2.0 {
                carRyczaltTextField.text = "1.15"
                carStawkaTextField.text = "0.90"
            }
        } else {
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.1673969667, blue: 0.07801140196, alpha: 0.5059663955)
        }
        
    }
    
    @IBAction func addNewCarButtonAction(_ sender: UIButton) {
        guard let carBrandString = carBrandTextField.text, let carModelString = carModelTextField.text, let carCapacity = carCapacityTextField.text, let carProductionYear = carProductionYearTextField.text, let carRyczalt = carRyczaltTextField.text, let carStawka = carStawkaTextField.text else { showAlert(title: "Error!", message: "Please fullfill all of the fields!")
            return }
        
        guard let carCapacityFloat = Float(carCapacity), let carProductionYearInt = Int(carProductionYear), let carStawkaFloat = Float(carStawka), let carRyczaltFloat = Float(carRyczalt) else { showAlert(title: "Error!", message: "Please enter right values!")
            return }
        
        FirebaseConnections.shared.addNewCar(carBrand: carBrandString, carModel: carModelString, carCapacity: carCapacityFloat, carProductionYear: carProductionYearInt, carRyczalt: carRyczaltFloat, carStawka: carStawkaFloat) { (success) in
            if success == false {
                self.showAlert(title: "Error!", message: "Something went wrong while adding new car...")
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }

}
