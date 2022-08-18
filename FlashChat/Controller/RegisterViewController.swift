//
//  RegisterViewController.swift
//  FlashChat
//
//  Created by Daniela Lima on 2022-07-18.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    //to display a pop-up with error message
    func showAlert (message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        //create a new account by passing the new user's email address and password
        //used optinal binding to turn emailTextField.text into a real String
        //chained emailTextField and passwordTextField, so if both are not nil and not fail, then it will continue and create user
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.showAlert(message: e.localizedDescription)
                } else {
                    //performSegue to nagivate to the ChatViewController
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
                }
            }
        }
    }
}
    
