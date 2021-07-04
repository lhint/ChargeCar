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
   
}
