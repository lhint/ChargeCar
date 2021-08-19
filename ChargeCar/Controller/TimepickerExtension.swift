//
//  TimepickerView.swift
//  ChargeCar
//
//  Created by Luke Hinton on 08/08/2021.
//  Time Picker View for selecting the time in the Schedule Screen.
//  Used from leoiphonedev/UIDatePicker-as-inputView-to-UITextField-Swift github
//

import UIKit

extension UITextField {
    
    func setTimePickerAsInputViewFor(target:Any, selector:Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        let timePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 200.0))
        timePicker.datePickerMode = .time
        self.inputView = timePicker
        
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 40.0))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tapCancel))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: nil, action: selector)
        toolBar.setItems([cancel,flexibleSpace, done], animated: false)
        self.inputAccessoryView = toolBar
        
    }
    
    func setTimePickerAsInputViewForBook(target:Any, selector:Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        let timePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 200.0))
        timePicker.datePickerMode = .time
        let dates = getTimeIntervalForDate()
        timePicker.minimumDate = dates.min
        timePicker.maximumDate = dates.max
    
        self.inputView = timePicker
        
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 40.0))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tapCancel))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: nil, action: selector)
        toolBar.setItems([cancel,flexibleSpace, done], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    func getTimeIntervalForDate()->(min : Date, max : Date){

    let calendar = Calendar.current
    var minDateComponent = calendar.dateComponents([.hour], from: Date())
    let first2start = Int(Global.shared.hostStartTimeDay.prefix(2))
    minDateComponent.hour = first2start // Start time
    let last2start = Int(Global.shared.hostStartTimeDay.suffix(2))
    minDateComponent.minute = last2start
        
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mma"
    let minDate = calendar.date(from: minDateComponent)
    print(" min date : \(formatter.string(from: minDate!))")

    var maxDateComponent = calendar.dateComponents([.hour], from: Date())
    let first2end = Int(Global.shared.hostEndTimeDay.prefix(2))
    maxDateComponent.hour = first2end //EndTime
    let last2end = Int(Global.shared.hostEndTimeDay.suffix(2))
    minDateComponent.minute = last2end

    let maxDate = calendar.date(from: maxDateComponent)
    print(" max date : \(formatter.string(from: maxDate!))")



    return (minDate!,maxDate!)
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
