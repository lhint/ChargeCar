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
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var alwaysShare: UISwitch!
    
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    var name = Global.shared.username
    var carReg = Global.shared.userReg
    var home = HomeViewController()
    var error = false
    let defaults = UserDefaults.standard
    
    //Data to load on startup
    override func viewDidLoad() {
        SVProgressHUD.dismiss()
        updateButton.isEnabled = false
        updateButton.backgroundColor = UIColor.gray
        nameField.placeholder = name
        carRegField.placeholder = carReg
        noMatch.isHidden = true
        scheduleButton.backgroundColor = .systemGreen
        //scheduleButton.isEnabled = true
        alwaysShare.isEnabled = true
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        nameField.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        carRegField.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        passwordField.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        password2Field.addTarget(self, action: #selector(validation), for: UIControl.Event.editingChanged)
        
        //Sets toggle value from variable
        if Global.shared.shareChargerOverride.contains("true") {
            shareToggle.isOn = true
            scheduleButton.isEnabled = true
            scheduleButton.backgroundColor = UIColor.systemGreen
        } else {
            shareToggle.isOn = false
            scheduleButton.isEnabled = false
            scheduleButton.backgroundColor = UIColor.gray
        }
        
        if Global.shared.returnedChargerName.isEmpty {
            scheduleButton.backgroundColor = .gray
            //scheduleButton.isEnabled = false
            alwaysShare.isEnabled = false
        }
    }
    
    //Is called whenever the screen reappears
    override func viewWillAppear(_ animated: Bool) {
        callShareValues()
        callTimeValues()
        callUserShareValues()
    }
    
    //Returns values from the database
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
    
    //Share toggle selection
    @IBAction func ShareToggle(_ sender: UISwitch) {
        //Removes from the map - Sets the showCharger parameter in firbase to true.
        
        if sender.isOn == false {
        self.ref.child(Global.shared.userUid).updateChildValues(["sharechargeroverride": "false"])
            scheduleButton.isEnabled = false
            scheduleButton.backgroundColor = UIColor.gray
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["sharechargeroverride": "true"])
            scheduleButton.isEnabled = true
            scheduleButton.backgroundColor = UIColor.systemGreen
        }
    }
    
    //Update button
    @IBAction func updateButton(_ sender: Any) {
        //Updates username
        if nameField.text!.isEmpty {
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["name": nameField.text!])
            Global.shared.username = nameField.text!
            let alert = UIAlertController(title: "Updated!", message: "Profile Information Updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
        
        if carRegField.text!.isEmpty {
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["carreg": carRegField.text!])
            let alert = UIAlertController(title: "Updated!", message: "Profile Information Updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
        
        //Updates car reg
        //Updates user password
        if passwordField.text!.isEmpty {
        } else {
            var answer = ""
            
            Auth.auth().currentUser?.updatePassword(to: password2Field.text!) { error in
                if error != nil {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .weakPassword:
                            answer = "Your password is too weak. Please make it more complex."
                        default:
                            answer = "Your password is too weak. Please make it more complex."
                            
                        }
                        let alert = UIAlertController(title: "Whoops...", message: "\(answer)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true)
                    }
                    
                } else {
                    let alert = UIAlertController(title: "Updated!", message: "Profile Information Updated.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
                    return
                }
            }
        }
    }

    //Schedule button
    @IBAction func scheduleButton(_ sender: Any) {
        if scheduleButton.backgroundColor == UIColor.gray {
            let alert = UIAlertController(title: "Whoops...", message: "Please setup the host first on the host screen from the menu.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        } else {
                performSegue(withIdentifier: "schedule", sender: self)
        }
        super.viewWillAppear(true)
    }
    
    //Return database values
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
    
    //Downloads values from database
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
        
        if nameField.text!.isEmpty && carRegField.text!.isEmpty && passwordField.text!.isEmpty && password2Field.text!.isEmpty {
            updateButton.isEnabled = false
            updateButton.backgroundColor = UIColor.gray
            noMatch.isHidden = false
        } else {
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
    
    //Searches for bookings that have past the current date
    func findAllBookingsToDelete() {
        self.ref.observeSingleEvent(of: .value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let bookingUserUid1 = snap.childSnapshot(forPath: "bookinguseruid1").value as? String
                let bookingUserUid2 = snap.childSnapshot(forPath: "bookinguseruid2").value as? String
                let bookingUserUid3 = snap.childSnapshot(forPath: "bookinguseruid3").value as? String
                let bookingUserUid4 = snap.childSnapshot(forPath: "bookinguseruid4").value as? String
                let bookingUserUid5 = snap.childSnapshot(forPath: "bookinguseruid5").value as? String
                let uid = snap.childSnapshot(forPath: "uid").value as? String
                
                print("UID: \(uid!)")
                if bookingUserUid1 == ("\(Global.shared.userUid)") {
                    self.deleteBookingSlot(uid: uid!, userUid: Global.shared.userUid, bookingUserUidValue: bookingUserUid1!, slot: 1)
                }
                if bookingUserUid2 == ("\(Global.shared.userUid)") {
                    self.deleteBookingSlot(uid: uid!, userUid: Global.shared.userUid, bookingUserUidValue: bookingUserUid2!, slot: 2)
                }
                if bookingUserUid3 == ("\(Global.shared.userUid)") {
                    self.deleteBookingSlot(uid: uid!, userUid: Global.shared.userUid, bookingUserUidValue: bookingUserUid3!, slot: 3)
                }
                if bookingUserUid4 == ("\(Global.shared.userUid)") {
                    self.deleteBookingSlot(uid: uid!, userUid: Global.shared.userUid, bookingUserUidValue: bookingUserUid4!, slot: 4)
                }
                if bookingUserUid5 == ("\(Global.shared.userUid)") {
                    self.deleteBookingSlot(uid: uid!, userUid: Global.shared.userUid, bookingUserUidValue: bookingUserUid5!, slot: 5)
                }
            }
        }
    }
    
    //Deletes bookings past the current date from the database
    func deleteBookingSlot(uid: String, userUid: String, bookingUserUidValue: String, slot: Int) {
        //print("Global UID \(userUid)")
        //print("booking slot \(slot): \(bookingUserUidValue)")
        
        switch slot {
        case 1:
            print("Deleting slot 1")
            self.ref.child(uid).updateChildValues(["bookedEndTime1": "", "bookedStartTime1": "", "bookingdatestamp1": "","bookinguseruid1": ""])
        case 2:
            print("Deleting slot 2")
            self.ref.child(uid).updateChildValues(["bookedEndTime2": "", "bookedStartTime2": "", "bookingdatestamp2": "","bookinguseruid2": ""])
        case 3:
            print("Deleting slot 3")
            self.ref.child(uid).updateChildValues(["bookedEndTime3": "", "bookedStartTime3": "", "bookingdatestamp3": "","bookinguseruid3": ""])
        case 4:
            print("Deleting slot 4")
            self.ref.child(uid).updateChildValues(["bookedEndTime4": "", "bookedStartTime4": "", "bookingdatestamp4": "","bookinguseruid4": ""])
        case 5:
            print("Deleting slot 5")
            self.ref.child(uid).updateChildValues(["bookedEndTime5": "", "bookedStartTime5": "", "bookingdatestamp5": "","bookinguseruid5": ""])
        default:
            print(0)
        }
    }
    
    //Deletes the users account from the database, authentication and current bookings
    @IBAction func deleteAccount(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "You are about to delete your account, all details will be deleted. Please enter your account password below:", preferredStyle: .alert)
        alert.addTextField { (textField) in
                textField.isSecureTextEntry = true
            }
        alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertAction.Style.default, handler: nil))
        //let submitAction = UIAlertAction(title: "", style: .default) { [unowned alert] _ in
          
        
        alert.addAction(UIAlertAction(title: "Delete!", style: .default, handler: { (action) -> Void in
        // Do action
            let password = alert.textFields![0].text
            // alert.addAction(submitAction)
         //Authenticate
         Auth.auth().signIn(withEmail: Global.shared.userEmail, password: password!) { authResult, error in
             if error != nil {
                 }
         }
        //Delete Account
            let user = Auth.auth().currentUser
            user?.delete { error in
              if let error = error {
                print(error)
                let alert = UIAlertController(title: "Error Deleting Account!", message: "Password Incorrect!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
              } else {
                //Delete data
                self.findAllBookingsToDelete()
                self.ref.child(Global.shared.userUid).removeValue()
                //Reset local device sign out variables
                Global.shared.signedIn = false
                Global.shared.signinUserEmail = ""
                self.defaults.set("Global.shared.signedIn", forKey: "SignedIn")
                self.defaults.set(Global.shared.signinUserEmail, forKey: "signedinUserEmail")
                Global.shared.newSaveEmail = false
                self.defaults.set(Global.shared.newSaveEmail, forKey: "NewSaveEmail")
                self.performSegue(withIdentifier: "backhome", sender: nil)
              }
            }
    }))
        self.present(alert, animated: true, completion: nil)
    }
}
