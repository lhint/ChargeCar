//
//  SignIn.swift
//  ChargeCar
//
//  Created by Luke Hinton on 30/06/2021.
//

import UIKit
import SVProgressHUD
import Firebase

class Login: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.email.delegate = self
        self.password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.email:
            self.password.becomeFirstResponder()
        case self.password:
            password.resignFirstResponder()
        default:
            self.password.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func loginButton(_ sender: Any) {
        //Code from the London App Brewery Udemy Course: https://www.udemy.com/course-dashboard-redirect/?course_id=1778502
        if let email = email.text, let password = password.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                 // report error
                    print(error ?? "Please enter a valid email and password")
                 return
                } else {
                    Global.shared.signedIn = true
                    self.performSegue(withIdentifier: "loginhome", sender: self)
                    //Change menu bar here
                    //Show username in menu
                    //Logged in message on home page
                }
            }
        }
    }
}
