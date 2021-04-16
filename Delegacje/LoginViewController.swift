//
//  LoginViewController.swift
//  Delegacje
//
//  Created by Jakub Iwaszek on 20/12/2020.
//

import UIKit

class LoginViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        print("dismissed")
    }
    
    
    @IBAction func createNewAccountButtonAction(_ sender: UIButton) {
        coordinator?.createNewAccount()
    }
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        guard let userLogin = loginTextField.text, let userPass = passwordTextField.text, userLogin.count > 0, userPass.count > 0 else { showAlert(title: "Error", message: "Uzupełnij pola!"); return }
        
        FirebaseConnections.shared.loginUserWithCredentials(userEmail: userLogin, userPassword: userPass) { (success) in
            if success {
                //TODO: Coordinator segue to main tab bar
                print(self.coordinator)
                self.coordinator?.openTabBar()
                self.coordinator = nil
                self.dismiss(animated: true)
            } else {
                self.showAlert(title: "Error", message: "Podane dane są niepoprawne!")
            }
        }
        
    }
    
}
