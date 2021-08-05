//
//  Account.swift
//  ChargeCar
//
//  Created by Luke Hinton on 12/07/2021.
//

import UIKit
import SVProgressHUD
import Firebase

class Account: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var carRegField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    @IBOutlet weak var shareToggle: UISwitch!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var noMatch: UILabel!
    
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    var name = Global.shared.username
    var carReg = Global.shared.userReg
    
    override func viewDidLoad() {
        SVProgressHUD.dismiss()
        updateButton.isEnabled = false
        updateButton.backgroundColor = UIColor.gray
        shareToggle.isOn = false
        nameField.placeholder = name
        carRegField.placeholder = carReg
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        if passwordField.text == "" {
            nameField.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
            carRegField.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        } else {
            passwordField.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
            password2Field.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        }
        
    }
    
    @IBAction func scheduleButton(_ sender: Any) {
        //Direct to schdule view
    }
    
    @IBAction func ShareToggle(_ sender: Any) {
        //Removes fron the map
    }
    
    @IBAction func updateButton(_ sender: Any) {
        //Updates username
        if nameField.text == "" {
            
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["name": nameField.text!])
            Global.shared.username = nameField.text!
        }
        
        if carRegField.text == "" {
            
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["carreg": carRegField.text!])
        }
        
        //Updates car reg
        
        //Updates user password
        if passwordField.text == "" {
        
        } else {
            Auth.auth().currentUser?.updatePassword(to: password2Field.text!) { error in
                    let alert = UIAlertController(title: "Woops...", message: "Error", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        let alert = UIAlertController(title: "Updated!", message: "Profile Information Updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //Validates the text field before the register button can be pressed
    @objc func validation() {
        //Text Field Validation check before button is enabled
        
        if password2Field.text != passwordField.text {
            updateButton.isEnabled = false
            updateButton.backgroundColor = UIColor.gray
            noMatch.isHidden = false
            
        } else {
            noMatch.isHidden = true
            updateButton.isEnabled = true
            updateButton.backgroundColor = UIColor.systemGreen
        }
    }
}
