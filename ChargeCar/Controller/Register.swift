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
    @IBOutlet weak var noMatch: UILabel!
    @IBOutlet weak var register: UIButton!
    
    
    let defaults = UserDefaults.standard
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noMatch.isHidden = true
        register.isUserInteractionEnabled = false
        register.backgroundColor = UIColor.gray
        SVProgressHUD.dismiss()
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        //Objective-C Line used to keep checking if the text field is vaild before enabling the submit button
        email.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        name.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        carReg.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        password2.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        
        self.name.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.password2.delegate = self
        self.carReg.delegate = self
        
        Global.shared.username = name.text ?? ""
        
    }
    
    //Keyboard return button moves curser to next text box
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
    
    //Validates the text field before the register button can be pressed
    @objc func validation() {
        //Text Field Validation check before button is enabled
        
        if email.text == "" || name.text == "" || carReg.text == "" {
            register.isUserInteractionEnabled = false
            register.backgroundColor = UIColor.gray
            
        } else {
            if  password2.text != password.text || password.text == "" || password2.text == "" {
                noMatch.isHidden = false
                register.isUserInteractionEnabled = false
                register.backgroundColor = UIColor.gray
            } else {
                noMatch.isHidden = true
                register.isUserInteractionEnabled = true
                register.backgroundColor = UIColor.systemGreen
            }
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        //Code from the London App Brewery Udemy Course: https://www.udemy.com/course-dashboard-redirect/?course_id=1778502
        
        if let email = email.text, let password2 = password2.text {
            var answer = ""
            
            Auth.auth().createUser(withEmail: email, password: password2, completion: { authResult, error in
                if error != nil {
                    // report error - Taken from: https://stackoverflow.com/questions/37449919/reading-firebase-auth-error-thrown-firebase-3-x-and-swift
                    // Presents the user with an error reason if the registration is unsuccesful.
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .emailAlreadyInUse:
                            answer = "Email your trying to use is already registered."
                        case .weakPassword:
                            answer = "Your password is too weak. Please make it more complex."
                        case .invalidEmail:
                            answer = "Your email address is invalid. Please try again with a vaild email address."
                        default:
                            answer = "Either your Email Address entered is incorrect or the password is not complex enough. Please try again."
                        }
                    }
                    print(answer)
                    let alert = UIAlertController(title: "Whoops...", message: "\(answer)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                    return
                } else {
                    //Sets the details in the global app variables.
                    Global.shared.signedIn = true
                    Global.shared.username = self.name.text!
                    Global.shared.userEmail = self.email.text!
                    Global.shared.userReg = self.carReg.text!
                    self.defaults.set(Global.shared.signedIn, forKey: "SignedIn")
                    self.defaults.set(Global.shared.username, forKey: "UserName")
                    self.performSegue(withIdentifier: "home", sender: self)
                    Global.shared.newSaveEmail = true
                    self.defaults.set(Global.shared.newSaveEmail, forKey: "NewSaveEmail")
                }
            })
        }
        
        //DVLA car check reg check API
        //Show name in menu
        //Logged in message on map page
        
    }
}
