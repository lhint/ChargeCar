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
        
        mondayShare.isOn = false
        tuesdayShare.isOn = false
        wednesdayShare.isOn = false
        thursdayShare.isOn = false
        fridayShare.isOn = false
        saturdayShare.isOn = false
        sundayShare.isOn = false

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
    }
    
    @objc func mondayStartSelected() {
        
        
        let timePicker = mondayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        mondayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["mondaystart": "\(time)"])
        
        self.mondayEnd.becomeFirstResponder()
    }
    
    @objc func mondayEndSelected() {
        
        
        let timePicker = mondayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        mondayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["mondayend": "\(time)"])
        
        self.tuesdayStart.becomeFirstResponder()
    }
    
    @objc func tuesdayStartSelected() {
        
        
        let timePicker = tuesdayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        tuesdayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["tuesdaystart": "\(time)"])
        
        self.tuesdayEnd.becomeFirstResponder()
    }
    
    @objc func tuesdayEndSelected() {
        
        
        let timePicker = tuesdayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        tuesdayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["tuesdayEnd": "\(time)"])
        
        self.wednesdayStart.becomeFirstResponder()
    }
    
    @objc func wednesdayStartSelected() {
        
        
        let timePicker = wednesdayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        wednesdayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["wednesdaystart": "\(time)"])
        
        self.wednesdayEnd.becomeFirstResponder()
    }
    
    @objc func wednesdayEndSelected() {
        
        
        let timePicker = wednesdayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        wednesdayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["wednesdayEnd": "\(time)"])
        
        self.thursdayStart.becomeFirstResponder()
    }
    
    @objc func thursdayStartSelected() {
        
        
        let timePicker = thursdayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        thursdayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["thursdaystart": "\(time)"])
        
        self.thursdayEnd.becomeFirstResponder()
    }
    
    @objc func thursdayEndSelected() {
        
        
        let timePicker = thursdayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        mondayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["thursdayend": "\(time)"])
        
        self.fridayStart.becomeFirstResponder()
    }
    
    @objc func fridayStartSelected() {
        
        
        let timePicker = fridayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        fridayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["fridaystart": "\(time)"])
        
        self.fridayEnd.becomeFirstResponder()
    }
    
    @objc func fridayEndSelected() {
        
        
        let timePicker = fridayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        fridayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["fridayend": "\(time)"])
        
        self.saturdayStart.becomeFirstResponder()
    }
    
    @objc func saturdayStartSelected() {
        
        
        let timePicker = saturdayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        saturdayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["saturdaystart": "\(time)"])
        
        self.saturdayEnd.becomeFirstResponder()
    }
    
    @objc func saturdayEndSelected() {
        
        
        let timePicker = saturdayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        saturdayEnd.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["saturdayend": "\(time)"])
        
        self.sundayStart.becomeFirstResponder()
        
    }
    
    @objc func sundayStartSelected() {
        
        
        let timePicker = sundayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
        sundayStart.text = time
        self.ref.child(Global.shared.userUid).updateChildValues(["sundaystart": "\(time)"])
        
        self.sundayEnd.becomeFirstResponder()
    }
    
    @objc func sundayEndSelected() {
        
        
        let timePicker = sundayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        let time = "\(hour) : \(minute)"
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
    
}
