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
    @IBOutlet weak var WednesdayStart: UITextField!
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
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        
    }
    
    //Time Picker
    @IBAction func timePickerAction(_ sender: Any) {
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
