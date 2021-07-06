//
//  Register.swift
//  
//
//  Created by Luke Hinton on 04/07/2021.
//

import UIKit
import SVProgressHUD
import Firebase

class Register: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var carReg: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.name.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.password2.delegate = self
        self.carReg.delegate = self

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.name:
            self.email.becomeFirstResponder()
        case self.email:
            self.password.becomeFirstResponder()
        case self.password:
            self.password2.becomeFirstResponder()
        case self.password2:
            self.carReg.becomeFirstResponder()
        case self.carReg:
            carReg.resignFirstResponder()
        default:
            self.email.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func registerButton(_ sender: Any) {
        //Code from the London App Brewery Udemy Course: https://www.udemy.com/course-dashboard-redirect/?course_id=1778502
        if let email = email.text, let password = password2.text {
        Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            if error != nil {
             // report error
                print(error ?? "Please enter a valid email and password")
             return
            } else {
                Global.shared.signedIn = true
                self.performSegue(withIdentifier: "home", sender: self)
            }
        })
        }
    }
    //UserDefaults to save if signedIn or not
    //Show username in menu
    //Logged in message on map page
    //Show sign in/ register errors as a UIAlertController
    //Include validation messages
    //Save rest of the required data to firebase realtime database
}
