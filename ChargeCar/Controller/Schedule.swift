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
    
    //Data to load on startup
    override func viewDidLoad() {
        
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
        
        checkShareValues()
        
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
    
    //Downloads and checks share value toggles from database
    func checkShareValues() {
        
        if Global.shared.userMondayShare.contains("true") {
            //print("MondayShare \(Global.shared.userMondayShare)")
            self.mondayShare.isOn = true
        } else {
            self.mondayShare.isOn = false
            //print("notCalledMondayShare \(Global.shared.userMondayShare)")
        }
        if Global.shared.userTuesdayShare.contains("true") {
            self.tuesdayShare.isOn = true
            print("User Tuesday Share \(Global.shared.userTuesdayShare)")
        } else {
            self.tuesdayShare.isOn = false
            print("Not Called User Tuesday Share \(Global.shared.userTuesdayShare)")
        }
        if Global.shared.userWednesdayShare.contains("true") {
            self.wednesdayShare.isOn = true
        } else {
            self.wednesdayShare.isOn = false
        }
        if Global.shared.userThursdayShare.contains("true") {
            self.thursdayShare.isOn = true
        } else {
            self.thursdayShare.isOn = false
        }
        if Global.shared.userFridayShare.contains("true") {
            self.fridayShare.isOn = true
        } else {
            self.fridayShare.isOn = false
        }
        if Global.shared.userSaturdayShare.contains("true") {
            self.saturdayShare.isOn = true
        } else {
            self.saturdayShare.isOn = false
        }
        if Global.shared.userSundayShare.contains("true") {
            self.sundayShare.isOn = true
        } else {
            self.sundayShare.isOn = false
        }
    }
    
    //Start and end time validaton
    func validation(startTime: String, startPlaceholder: String, endTime: String, textField: UITextField) {
        if startTime.isEmpty {
            if startPlaceholder > endTime {
                textField.text = "23:59"
            }
        } else if startTime > endTime {
            textField.text = "23:59"
        }
    }
    
    //Additional start time validation
    func validationStart(startTime: String, endPlaceholder: String, endTime: String, textField: UITextField) {
        if startTime.isEmpty {
            if endPlaceholder < startTime {
                textField.text = "00:00"
            }
        }
    }
    
    //Time text field functions
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
        validation(startTime: mondayStart.text!, startPlaceholder: mondayStart.placeholder ?? "", endTime: mondayEnd.text!, textField: mondayEnd)
        validationStart(startTime: mondayStart.text!, endPlaceholder: mondayEnd.placeholder ?? "", endTime: mondayEnd.text!, textField: mondayStart)
        self.ref.child(Global.shared.userUid).updateChildValues(["mondayend": "\(time)"])
        self.mondayEnd.resignFirstResponder()
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
        validation(startTime: tuesdayStart.text!, startPlaceholder: tuesdayStart.placeholder ?? "", endTime: tuesdayEnd.text!, textField: tuesdayEnd)
        validationStart(startTime: tuesdayStart.text!, endPlaceholder: tuesdayEnd.placeholder ?? "", endTime: tuesdayEnd.text!, textField: tuesdayStart)
        self.ref.child(Global.shared.userUid).updateChildValues(["tuesdayend": "\(time)"])
        
        self.tuesdayEnd.resignFirstResponder()
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
        validation(startTime: wednesdayStart.text!, startPlaceholder: wednesdayStart.placeholder ?? "", endTime: wednesdayEnd.text!, textField: wednesdayEnd)
        validationStart(startTime: wednesdayStart.text!, endPlaceholder: wednesdayEnd.placeholder ?? "", endTime: wednesdayEnd.text!, textField: wednesdayStart)
        self.ref.child(Global.shared.userUid).updateChildValues(["wednesdayend": "\(time)"])
        
        self.wednesdayEnd.resignFirstResponder()
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
        validation(startTime: thursdayStart.text!, startPlaceholder: thursdayStart.placeholder ?? "", endTime: thursdayEnd.text!, textField: thursdayEnd)
        validationStart(startTime: thursdayStart.text!, endPlaceholder: thursdayEnd.placeholder ?? "", endTime: thursdayEnd.text!, textField: thursdayStart)
        self.ref.child(Global.shared.userUid).updateChildValues(["thursdayend": "\(time)"])
        
        self.thursdayEnd.resignFirstResponder()
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
        validation(startTime: fridayStart.text!, startPlaceholder: fridayStart.placeholder ?? "", endTime: fridayEnd.text!, textField: fridayEnd)
        validationStart(startTime: fridayStart.text!, endPlaceholder: fridayEnd.placeholder ?? "", endTime: fridayEnd.text!, textField: fridayStart)
        self.ref.child(Global.shared.userUid).updateChildValues(["fridayend": "\(time)"])
        
        self.fridayEnd.resignFirstResponder()
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
        validation(startTime: saturdayStart.text!, startPlaceholder: saturdayStart.placeholder ?? "", endTime: saturdayEnd.text!, textField: saturdayEnd)
        validationStart(startTime: saturdayStart.text!, endPlaceholder: saturdayEnd.placeholder ?? "", endTime: saturdayEnd.text!, textField: saturdayStart)
        self.ref.child(Global.shared.userUid).updateChildValues(["saturdayend": "\(time)"])
        
        self.saturdayEnd.resignFirstResponder()
        
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
        validation(startTime: sundayStart.text!, startPlaceholder: sundayStart.placeholder ?? "", endTime: sundayEnd.text!, textField: sundayEnd)
        validationStart(startTime: sundayStart.text!, endPlaceholder: sundayEnd.placeholder ?? "", endTime: sundayEnd.text!, textField: sundayStart)
        self.ref.child(Global.shared.userUid).updateChildValues(["sundayend": "\(time)"])
        
        self.sundayEnd.resignFirstResponder()
    }
    
    //Share toggls functions
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
    
}
