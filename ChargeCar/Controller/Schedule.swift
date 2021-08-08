//
//  Schedule.swift
//  ChargeCar
//
//  Created by Luke Hinton on 06/08/2021.
//

import UIKit

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
        mondayStart.text = "\(hour) : \(minute)"
        
        self.mondayEnd.becomeFirstResponder()
    }
    
    @objc func mondayEndSelected() {
        
        
        let timePicker = mondayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        mondayEnd.text = "\(hour) : \(minute)"
        
        self.tuesdayStart.becomeFirstResponder()
    }
    
    @objc func tuesdayStartSelected() {
        
        
        let timePicker = tuesdayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        tuesdayStart.text = "\(hour) : \(minute)"
        
        self.tuesdayEnd.becomeFirstResponder()
    }
    
    @objc func tuesdayEndSelected() {
        
        
        let timePicker = tuesdayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        tuesdayEnd.text = "\(hour) : \(minute)"
        
        self.wednesdayStart.becomeFirstResponder()
    }
    
    @objc func wednesdayStartSelected() {
        
        
        let timePicker = wednesdayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        wednesdayStart.text = "\(hour) : \(minute)"
        
        self.wednesdayEnd.becomeFirstResponder()
    }
    
    @objc func wednesdayEndSelected() {
        
        
        let timePicker = wednesdayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        wednesdayEnd.text = "\(hour) : \(minute)"
        
        self.thursdayStart.becomeFirstResponder()
    }
    
    @objc func thursdayStartSelected() {
        
        
        let timePicker = thursdayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        thursdayStart.text = "\(hour) : \(minute)"
        
        self.thursdayEnd.becomeFirstResponder()
    }
    
    @objc func thursdayEndSelected() {
        
        
        let timePicker = thursdayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        thursdayEnd.text = "\(hour) : \(minute)"
        
        self.fridayStart.becomeFirstResponder()
    }
    
    @objc func fridayStartSelected() {
        
        
        let timePicker = fridayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        fridayStart.text = "\(hour) : \(minute)"
        
        self.fridayEnd.becomeFirstResponder()
    }
    
    @objc func fridayEndSelected() {
        
        
        let timePicker = fridayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        fridayEnd.text = "\(hour) : \(minute)"
        
        self.saturdayStart.becomeFirstResponder()
    }
    
    @objc func saturdayStartSelected() {
        
        
        let timePicker = saturdayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        saturdayStart.text = "\(hour) : \(minute)"
        
        self.saturdayEnd.becomeFirstResponder()
    }
    
    @objc func saturdayEndSelected() {
        
        
        let timePicker = saturdayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        saturdayEnd.text = "\(hour) : \(minute)"
        
        self.sundayStart.becomeFirstResponder()
        
    }
    
    @objc func sundayStartSelected() {
        
        
        let timePicker = sundayStart.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        sundayStart.text = "\(hour) : \(minute)"
        
        self.sundayEnd.becomeFirstResponder()
    }
    
    @objc func sundayEndSelected() {
        
        
        let timePicker = sundayEnd.inputView as? UIDatePicker
        let date = (timePicker?.date)!
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        sundayEnd.text = "\(hour) : \(minute)"
        
        self.sundayEnd.resignFirstResponder()
    }
    
    
    @IBAction func mondayShareAction(_ sender: Any) {
    }
    
    @IBAction func tuesdayShareAction(_ sender: Any) {
    }
    
    @IBAction func wednesdayShareAction(_ sender: Any) {
    }
    
    @IBAction func thursdayShareAction(_ sender: Any) {
    }
    
    @IBAction func fridayShareAction(_ sender: Any) {
    }
    
    @IBAction func saturdayShareAction(_ sender: Any) {
    }
    
    @IBAction func sundayShareAction(_ sender: Any) {
    }
    
}
