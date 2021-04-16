//
//  RegisterViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 20/12/2020.
//

import UIKit

class RegisterViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        guard let userLogin = loginTextField.text, let userPass = passwordTextField.text, let userName = nameTextField.text, let userSurname = surnameTextField.text, userLogin.count > 0, userPass.count > 0 else { showAlert(title: "Error", message: "Uzupełnij dane"); return }
        let fullName = userName + " " + userSurname
        FirebaseConnections.shared.registerNewUser(userEmail: userLogin, userPassword: userPass, fullName: fullName) { (success) in
            if success {
                self.showAlert(title: "Sukces", message: "Pomyślnie zarejestrowano użytkownika!")
                //self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil) //TODO: Dissmisuje alert
            } else {
                self.showAlert(title: "Error", message: "Podczas rejestracji użytkownika wystąpił błąd!")
            }
        }
    }
    
}

//TODO: Przeniesc do extensions

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}
