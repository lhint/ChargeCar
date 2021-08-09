//
//  Schedule.swift
//  ChargeCar
//
//  Created by Luke Hinton on 06/08/2021.
//

import UIKit
import Firebase

class Schedule: UIViewController {
    
    @IBOutlet weak var mondayStart: UITextField!
    @IBOutlet weak var mondayEnd: UITextField!
    @IBOutlet weak var tuesdayStart: UITextField!
    @IBOutlet weak var tuesdayEnd: UITextField!
    @IBOutlet weak var wednesdayStart: UITextField!
    @IBOutlet weak var wednesdayEnd: UITextField!
    @IBOutlet weak var thursdayStart: UITextField!
    @IBOutlet weak var thursdayEnd: UITextField!
    @IBOutlet weak var fridayStart: UITextField!
    @IBOutlet weak var fridayEnd: UITextField!
    @IBOutlet weak var saturdayStart: UITextField!
    @IBOutlet weak var saturdayEnd: UITextField!
    @IBOutlet weak var sundayStart: UITextField!
    @IBOutlet weak var sundayEnd: UITextField!
    
    @IBOutlet weak var mondayShare: UISwitch!
    @IBOutlet weak var tuesdayShare: UISwitch!
    @IBOutlet weak var wednesdayShare: UISwitch!
    @IBOutlet weak var thursdayShare: UISwitch!
    @IBOutlet weak var fridayShare: UISwitch!
    @IBOutlet weak var saturdayShare: UISwitch!
    @IBOutlet weak var sundayShare: UISwitch!
    
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    
    override func viewDidLoad() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        mondayStart.setTimePickerAsInputViewFor(target: self, selector: #selector(mondayStartSelected))
        mondayEnd.setTimePickerAsInputViewFor(target: self, selector: #selector(mondayEndSelected))
        tuesdayStart.setTimePickerAsInputViewFor(target: self, selector: #selector(tuesdayStartSelected))
        tuesdayEnd.setTimePickerAsInputViewFor(target: self, selector: #selector(tuesdayEndSelected))
        wednesdayStart.setTimePickerAsInputViewFor(target: self, selector: #selector(wednesdayStartSelected))
        wednesdayEnd.setTimePickerAsInputViewFor(target: self, selector: #selector(wednesdayEndSelected))
        thursdayStart.setTimePickerAsInputViewFor(target: self, selector: #selector(thursdayStartSelected))
        thursdayEnd.setTimePickerAsInputViewFor(target: self, selector: #selector(thursdayEndSelected))
        fridayStart.setTimePickerAsInputViewFor(target: self, selector: #selector(fridayStartSelected))
        fridayEnd.setTimePickerAsInputViewFor(target: self, selector: #selector(fridayEndSelected))
        saturdayStart.setTimePickerAsInputViewFor(target: self, selector: #selector(saturdayStartSelected))
        saturdayEnd.setTimePickerAsInputViewFor(target: self, selector: #selector(saturdayEndSelected))
        sundayStart.setTimePickerAsInputViewFor(target: self, selector: #selector(sundayStartSelected))
        sundayEnd.setTimePickerAsInputViewFor(target: self, selector: #selector(sundayEndSelected))
        
        callShareValues()
        
        mondayStart.placeholder = Global.shared.mondayStart
        mondayEnd.placeholder = Global.shared.mondayEnd
        tuesdayStart.placeholder = Global.shared.tuesdayStart
        tuesdayEnd.placeholder = Global.shared.tuesdayEnd
        wednesdayStart.placeholder = Global.shared.wednesdayStart
        wednesdayEnd.placeholder = Global.shared.wednesdayEnd
        thursdayStart.placeholder = Global.shared.thursdayStart
        thursdayEnd.placeholder = Global.shared.thursdayEnd
        fridayStart.placeholder = Global.shared.fridayStart
        fridayEnd.placeholder = Global.shared.fridayEnd
        saturdayStart.placeholder = Global.shared.saturdayStart
        saturdayEnd.placeholder = Global.shared.saturdayEnd
        sundayStart.placeholder = Global.shared.sundayStart
        sundayEnd.placeholder = Global.shared.sundayEnd
        
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
        checkShareValues()
    }
    
    func checkShareValues() {
        
        print("Check \(Global.shared.mondayCharger)")
        if Global.shared.mondayCharger.contains("true") {
            //print("MondayShare \(Global.shared.mondayCharger)")
            self.mondayShare.isOn = true
        } else {
            self.mondayShare.isOn = false
            //print("notCalledMondayShare \(Global.shared.mondayCharger)")
        }
        if Global.shared.tuesdayCharger.contains("true") {
            self.tuesdayShare.isOn = true
        } else {
            self.tuesdayShare.isOn = false
        }
        if Global.shared.wednesdayCharger.contains("true") {
            self.wednesdayShare.isOn = true
        } else {
            self.wednesdayShare.isOn = false
        }
        if Global.shared.thursdayCharger.contains("true") {
            self.thursdayShare.isOn = true
        } else {
            self.thursdayShare.isOn = false
        }
        if Global.shared.fridayCharger.contains("true") {
            self.fridayShare.isOn = true
        } else {
            self.fridayShare.isOn = false
        }
        if Global.shared.saturdayCharger.contains("true") {
            self.saturdayShare.isOn = true
        } else {
            self.saturdayShare.isOn = false
        }
        if Global.shared.sundayCharger.contains("true") {
            self.sundayShare.isOn = true
        } else {
            self.sundayShare.isOn = false
        }
    }
    
    @objc func mondayStartSelected() {
        
        
        let timePicker = mondayStart.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        mondayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["mondaystart": "\(time)"])
        
        self.mondayEnd.becomeFirstResponder()
    }
    
    @objc func mondayEndSelected() {
        
        
        let timePicker = mondayEnd.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        mondayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["mondayend": "\(time)"])
        
        self.tuesdayStart.becomeFirstResponder()
    }
    
    @objc func tuesdayStartSelected() {
        
        
        let timePicker = tuesdayStart.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        tuesdayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["tuesdaystart": "\(time)"])
        
        self.tuesdayEnd.becomeFirstResponder()
    }
    
    @objc func tuesdayEndSelected() {
        
        
        let timePicker = tuesdayEnd.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        tuesdayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["tuesdayend": "\(time)"])
        
        self.wednesdayStart.becomeFirstResponder()
    }
    
    @objc func wednesdayStartSelected() {
        
        
        let timePicker = wednesdayStart.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        wednesdayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["wednesdaystart": "\(time)"])
        
        self.wednesdayEnd.becomeFirstResponder()
    }
    
    @objc func wednesdayEndSelected() {
        
        
        let timePicker = wednesdayEnd.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        wednesdayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["wednesdayend": "\(time)"])
        
        self.thursdayStart.becomeFirstResponder()
    }
    
    @objc func thursdayStartSelected() {
        
        
        let timePicker = thursdayStart.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        thursdayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["thursdaystart": "\(time)"])
        
        self.thursdayEnd.becomeFirstResponder()
    }
    
    @objc func thursdayEndSelected() {
        
        
        let timePicker = thursdayEnd.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        thursdayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["thursdayend": "\(time)"])
        
        self.fridayStart.becomeFirstResponder()
    }
    
    @objc func fridayStartSelected() {
        
        
        let timePicker = fridayStart.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        fridayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["fridaystart": "\(time)"])
        
        self.fridayEnd.becomeFirstResponder()
    }
    
    @objc func fridayEndSelected() {
        
        
        let timePicker = fridayEnd.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        fridayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["fridayend": "\(time)"])
        
        self.saturdayStart.becomeFirstResponder()
    }
    
    @objc func saturdayStartSelected() {
        
        
        let timePicker = saturdayStart.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        saturdayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["saturdaystart": "\(time)"])
        
        self.saturdayEnd.becomeFirstResponder()
    }
    
    @objc func saturdayEndSelected() {
        
        
        let timePicker = saturdayEnd.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        saturdayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["saturdayend": "\(time)"])
        
        self.sundayStart.becomeFirstResponder()
        
    }
    
    @objc func sundayStartSelected() {
        
        
        let timePicker = sundayStart.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        sundayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["sundaystart": "\(time)"])
        
        self.sundayEnd.becomeFirstResponder()
    }
    
    @objc func sundayEndSelected() {
        
        
        let timePicker = sundayEnd.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        sundayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["sundayend": "\(time)"])
        
        self.sundayEnd.resignFirstResponder()
    }
    
    
    @IBAction func mondayShareAction(_ sender: UISwitch) {
        if sender.isOn == false {
            self.ref.child(Global.shared.userUid).updateChildValues(["mondayshare": "false"])
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["mondayshare": "true"])
        }
    }
    
    @IBAction func tuesdayShareAction(_ sender: UISwitch) {
        if sender.isOn == false {
            self.ref.child(Global.shared.userUid).updateChildValues(["tuesdayshare": "false"])
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["tuesdayshare": "true"])
        }
    }
    
    @IBAction func wednesdayShareAction(_ sender: UISwitch) {
        if sender.isOn == false {
            self.ref.child(Global.shared.userUid).updateChildValues(["wednesdayshare": "false"])
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["wednesdayshare": "true"])
        }
    }
    
    @IBAction func thursdayShareAction(_ sender: UISwitch) {
        if sender.isOn == false {
            self.ref.child(Global.shared.userUid).updateChildValues(["thursdayshare": "false"])
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["thursdayshare": "true"])
        }
    }
    
    @IBAction func fridayShareAction(_ sender: UISwitch) {
        if sender.isOn == false {
            self.ref.child(Global.shared.userUid).updateChildValues(["fridayshare": "false"])
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["fridayshare": "true"])
        }
    }
    
    @IBAction func saturdayShareAction(_ sender: UISwitch) {
        if sender.isOn == false {
            self.ref.child(Global.shared.userUid).updateChildValues(["saturdayshare": "false"])
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["saturdayshare": "true"])
        }
    }
    
    @IBAction func sundayShareAction(_ sender: UISwitch) {
        if sender.isOn == false {
            self.ref.child(Global.shared.userUid).updateChildValues(["sundayshare": "false"])
        } else {
            self.ref.child(Global.shared.userUid).updateChildValues(["sundayshare": "true"])
        }
    }
    
    func calculateSchedule() {
        //Check if days are enabled
        //check if its within the time
        // if yes sharechar
    }
    
}
