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
    @IBOutlet weak var signInButton: UIButton!
    
    
    let defaults = UserDefaults.standard
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.email.delegate = self
        self.password.delegate = self
        
        email.addTarget(self, action: #selector(passwordValidation), for: UIControl.Event.editingChanged)
        password.addTarget(self, action: #selector(passwordValidation), for: UIControl.Event.editingChanged)
        
        signInButton.isUserInteractionEnabled = false
        signInButton.backgroundColor = UIColor.gray
        

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
        
        let userEmail = email.text!
        
        if let email = email.text, let password = password.text {
            var answer = ""
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    // report error - Taken from: https://stackoverflow.com/questions/37449919/reading-firebase-auth-error-thrown-firebase-3-x-and-swift
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .invalidEmail:
                            answer = "Incorrect Email Address. Please try again."
                        case .wrongPassword:
                            answer = "Incorrect Password. Please try again."
                        default:
                            answer = "Either your Email Address or Password is wrong. Please try again."
                        }
                    }
                    print(answer)
                    let alert = UIAlertController(title: "Woops...", message: "\(answer)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                    return
                } else {
                    Global.shared.signedIn = true
                    self.defaults.set(Global.shared.signedIn, forKey: "SignedIn")
                    Global.shared.signinUserEmail = userEmail
                    print("Sign in - signed in user email \(Global.shared.signinUserEmail)")
                    self.defaults.set(Global.shared.userEmail, forKey: "email")
                    self.defaults.set(Global.shared.signinUserEmail, forKey: "signedinUserEmail")
                    self.performSegue(withIdentifier: "loginhome", sender: self)
                    Global.shared.newSaveEmail = true
                    self.defaults.set(Global.shared.newSaveEmail, forKey: "NewSaveEmail")
                    
                }
            }
        }
    }
    
    @objc func passwordValidation() {
        
        if email.text == "" || password.text == "" {
            signInButton.isUserInteractionEnabled = false
            signInButton.backgroundColor = UIColor.gray
        } else {
            signInButton.isUserInteractionEnabled = true
            signInButton.backgroundColor = UIColor.systemGreen
        }
    }

    @IBAction func forgotPassword(_ sender: Any) {
        var answer = ""
        
        Auth.auth().sendPasswordReset(withEmail: self.email.text!) { error in
            
            if error != nil {
                // report error - Taken from: https://stackoverflow.com/questions/37449919/reading-firebase-auth-error-thrown-firebase-3-x-and-swift
                // Presents the user with an error reason if the registration is unsuccesful.
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .invalidEmail:
                        answer = "Email is not correct please follow format XXX@XXX.com."
                    case .missingEmail:
                        answer = "Please enter an email address."
                    default:
                        answer = "Please enter a vaild email address"
            
                    }
                }
                let alert = UIAlertController(title: "Whoops", message: "\(answer)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue...", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Reset!", message: "Please check your email for the reset link.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue...", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
    }
}
