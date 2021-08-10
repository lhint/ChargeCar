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
    var home = HomeViewController()
    
    override func viewDidLoad() {
        SVProgressHUD.dismiss()
        updateButton.isEnabled = false
        updateButton.backgroundColor = UIColor.gray
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
        
        if Global.shared.shareChargerOverride.contains("true") {
            shareToggle.isOn = true
        } else {
            shareToggle.isOn = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShareValues()
        callTimeValues()
        callUserShareValues()
    }
    
    func callTimeValues() {
        
        //Get exisiting times to show as place holders in the scheduel screen
        
        DispatchQueue.global(qos: .default).async {

          // 2
          let group = DispatchGroup()
            
            group.enter()
          
            self.ref.child("\(Global.shared.userUid)").child("mondaystart").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.mondayStart = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
             self.ref.child("\(Global.shared.userUid)").child("mondayend").observeSingleEvent(of: .value, with: { (snapshot) in
              
              var value = ""

                 if snapshot.exists() {

                     value = snapshot.value as? String ?? ""
                     print("Username: \(value)")
                     Global.shared.mondayEnd = value
                     
                 } else {
                     print("Error")

                 }
             })
            
            self.ref.child("\(Global.shared.userUid)").child("tuesdaystart").observeSingleEvent(of: .value, with: { (snapshot) in
                
             var value = ""

                if snapshot.exists() {

                    value = snapshot.value as? String ?? ""
                    print("Carreg: \(value)")
                    Global.shared.tuesdayStart = value
                    
                } else {
                    print("Error")

                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("tuesdayend").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    Global.shared.tuesdayEnd = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("wednesdaystart").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    Global.shared.wednesdayStart = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("wednesdayend").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.wednesdayEnd = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("thursdaystart").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.thursdayStart = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("thursdayend").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.thursdayEnd = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("fridaystart").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.fridayStart = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("fridayend").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.fridayEnd = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("saturdaystart").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.saturdayStart = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("saturdayend").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.saturdayEnd = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("sundaystart").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.sundayStart = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("sundayend").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.sundayEnd = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
        
            group.leave()
            
            group.wait()

          // 6
          DispatchQueue.main.async {

          }

        }
        
    }
    
    @IBAction func ShareToggle(_ sender: UISwitch) {
        //Removes from the map - Sets the showCharger parameter in firbase to true.
        
        if sender.isOn == false {
        self.ref.child(Global.shared.userUid).updateChildValues(["sharechargeroverride": "false"])
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["sharechargeroverride": "true"])
            //print("is on")
        }
//        let alert = UIAlertController(title: "Info", message: "You have either switched your host on or off. To see this change on the map please choose restart, to see the change later press close.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("Restart", comment: "Default action"), style: .default, handler: { (action) -> Void in
//            if let navController = self.navigationController {
//                navController.popViewController(animated: true)
//            }
//
//        }))
//        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
//        present(alert, animated: true)
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
    
    @IBAction func scheduleButton(_ sender: Any) {
        performSegue(withIdentifier: "schedule", sender: self)
        super.viewWillAppear(true)
    }
    
    func callShareValues() {
        self.ref.observeSingleEvent(of: .value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let mondayCharger = snap.childSnapshot(forPath: "mondayshare").value as? String
                let tuesdayCharger = snap.childSnapshot(forPath: "tuesdayshare").value as? String
                let wednesdayCharger = snap.childSnapshot(forPath: "wednesdayshare").value as? String
                let thursdayCharger = snap.childSnapshot(forPath: "thursdayshare").value as? String
                let fridayCharger = snap.childSnapshot(forPath: "fridayshare").value as? String
                let saturdayCharger = snap.childSnapshot(forPath: "saturdayshare").value as? String
                let sundayCharger = snap.childSnapshot(forPath: "sundayshare").value as? String
                
                if ((mondayCharger?.contains("true")) != nil) {
                    Global.shared.mondayCharger = mondayCharger ?? "false"
                }
                if ((tuesdayCharger?.contains("true")) != nil) {
                    Global.shared.tuesdayCharger = tuesdayCharger ?? "false"
                }
                if ((wednesdayCharger?.contains("true")) != nil) {
                    Global.shared.wednesdayCharger = wednesdayCharger ?? "false"
                }
                if ((thursdayCharger?.contains("true")) != nil) {
                    Global.shared.thursdayCharger = thursdayCharger ?? "false"
                }
                if ((fridayCharger?.contains("true")) != nil) {
                    Global.shared.fridayCharger = fridayCharger ?? "false"
                }
                if ((saturdayCharger?.contains("true")) != nil) {
                    Global.shared.saturdayCharger = saturdayCharger ?? "false"
                }
                if ((sundayCharger?.contains("true")) != nil) {
                    Global.shared.sundayCharger = sundayCharger ?? "false"
                }
            }
        }
    }
    
    func callUserShareValues() {
        
        DispatchQueue.global(qos: .default).async {

          // 2
          let group = DispatchGroup()
            
            group.enter()
          
            self.ref.child("\(Global.shared.userUid)").child("mondayshare").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.userMondayShare = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
              //Get username for signed in user to display in menu
             self.ref.child("\(Global.shared.userUid)").child("tuesdayshare").observeSingleEvent(of: .value, with: { (snapshot) in
                 // Get item value
              var value = ""

                 if snapshot.exists() {

                     value = snapshot.value as? String ?? ""
                     Global.shared.userTuesdayShare = value
                     
                 } else {
                     print("Error")

                 }
             })
            
            //get car reg
            self.ref.child("\(Global.shared.userUid)").child("wednesdayshare").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
             var value = ""

                if snapshot.exists() {

                    value = snapshot.value as? String ?? ""
                    Global.shared.userWednesdayShare = value
                    print("User Wednesday Share: \(Global.shared.userWednesdayShare)")
                } else {
                    print("Error")

                }
            })
            
            //Get charger name
            self.ref.child("\(Global.shared.userUid)").child("thursdayshare").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    Global.shared.userThursdayShare = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            //Get cooridnate latitude
            self.ref.child("\(Global.shared.userUid)").child("fridayshare").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    Global.shared.userFridayShare = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            //get coordinate longitude
            self.ref.child("\(Global.shared.userUid)").child("saturdayshare").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.userSaturdayShare = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            //get coordinate longitude
            self.ref.child("\(Global.shared.userUid)").child("sundayshare").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                
                if snapshot.exists() {
                    
                    Global.shared.userSundayShare = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
        
            group.leave()
            
            group.wait()

          // 6
          DispatchQueue.main.async {
            
          }

        }
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
