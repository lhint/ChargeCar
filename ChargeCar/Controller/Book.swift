//
//  Book.swift
//  ChargeCar
//
//  Created by Luke Hinton on 11/08/2021.
//

import UIKit
import Firebase

class Book: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var selectDay: UITextField!
    @IBOutlet weak var startTimeField: UITextField!
    @IBOutlet weak var endTimeField: UITextField!
    
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let titles = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"] //Replace with set host days
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    var privateHostUid = Global.shared.userUid
    var startTimeDay = ""
    var endTimeDay = ""
    var bookingStart1 = ""
    var bookingEnd1 = ""
    var bookingStart2 = ""
    var bookingEnd2 = ""
    var bookingStart3 = ""
    var bookingEnd3 = ""
    var bookingStart4 = ""
    var bookingEnd4 = ""
    var totalBookings = 0
    var selectStartTime = ""
    var selectedEndTime = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.selectDay.inputView = self.pickerView
        self.selectDay.inputAccessoryView = self.pickerView.toolbar

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self

        self.pickerView.reloadAllComponents()
        
        
        //Set start and end time from Global parameters.
        startTimeField.placeholder = Global.shared.hostStartTimeDay
        endTimeField.placeholder = Global.shared.hostEndTimeDay
        startTimeField.setTimePickerAsInputViewForBook(target: self, selector: #selector(startTimeSelected))
        endTimeField.setTimePickerAsInputViewForBook(target: self, selector: #selector(endTimeSelected))
        
    }
    

    
    @IBAction func update(_ sender: AnyObject) {
        print("reloaded")
        pickerView.reloadAllComponents()
        pickerView.reloadInputViews()
        startTimeField.setTimePickerAsInputViewForBook(target: self, selector: #selector(startTimeSelected))
        endTimeField.setTimePickerAsInputViewForBook(target: self, selector: #selector(endTimeSelected))
    }
    
    @objc func startTimeSelected() {
        let timePicker = startTimeField.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        startTimeField.text = time
        self.endTimeField.becomeFirstResponder()
    }
    
    @objc func endTimeSelected() {
        let timePicker = endTimeField.inputView as? UIDatePicker
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timePicker!.date)
        endTimeField.text = time
        self.selectedEndTime = time
        
        self.endTimeField.resignFirstResponder()
    }
    
    func allocateBookings(start: String, end: String) -> Int {
        var bookingNumber = 0
        if totalBookings == 0 {
            bookingStart1 = start
            bookingEnd1 = end
            bookingNumber = 1
        } else if totalBookings == 1 {
            bookingStart2 = start
            bookingEnd2 = end
            bookingNumber = 2
        } else if totalBookings == 3 {
            bookingStart3 = start
            bookingEnd3 = end
            bookingNumber = 3
        } else if totalBookings == 4 {
            bookingStart4 = start
            bookingEnd4 = end
            bookingNumber = 4
        }
        return bookingNumber
    }
    
    @IBAction func book(_ sender: Any) {
    
        self.ref.child(self.privateHostUid).updateChildValues(["bookedStartTime\(allocateBookings(start: selectStartTime, end: selectedEndTime))": "\(selectStartTime)", "bookedday": "\(selectDay.text?.lowercased() ?? "")","totalbookings" : "\(totalBookings)", "bookedEndTime\(allocateBookings(start: selectStartTime, end: selectedEndTime))": "\(selectedEndTime)", "bookinguid" : "\(Global.shared.userUid)"])
        
        let alert = UIAlertController(title: "Booked", message: "You have now booked. Start time \(self.selectStartTime), End time: \(self.selectedEndTime)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true)
        
        //Only show days set by host. Collect and add to the array.
        //Add if statement to homeViewController to check the booked time and gray out green booking for that time.
        //Validate that if that time, or any of the choosen time presents a UIAlert and stops them booking it.
        
    }
    
    func dayCheck(day: String) {
        //if selectDay.text?.lowercased() == "\(day)" {
            print("dayCheck Called")
            let lowerday = day.lowercased()
            self.startTimeDay = "\(lowerday)start"
            print("startTimeDay \(self.startTimeDay)")
            self.endTimeDay = "\(lowerday)end"
            print("endTimeDay \(self.endTimeDay)")
            
            DispatchQueue.global(qos: .default).async {

              // 2
              let group = DispatchGroup()
                
                group.enter()
              
                self.ref.child("\(self.privateHostUid)").child("\(self.startTimeDay)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    
                    if snapshot.exists() {
                        
                        Global.shared.hostStartTimeDay = snapshot.value as? String ?? ""
                        self.startTimeField.placeholder = Global.shared.hostStartTimeDay
                    } else {
                        print("Error")
                        
                    }
                })
                
                self.ref.child("\(self.privateHostUid)").child("\(self.endTimeDay)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    
                    if snapshot.exists() {
                        
                        Global.shared.hostEndTimeDay = snapshot.value as? String ?? ""
                        self.endTimeField.placeholder = Global.shared.hostEndTimeDay
                        
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
    //}
}

extension Book: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Global.shared.bookings.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Global.shared.bookings[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectDay.text = Global.shared.bookings[row]
        Global.shared.hostSelectedDay = self.selectDay.text!
        dayCheck(day: "\(Global.shared.hostSelectedDay)")
    }
    
}

extension Book: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.selectDay.text = self.titles[row]
        self.selectDay.resignFirstResponder()
    }

    func didTapCancel() {
        self.selectDay.text = nil
        self.selectDay.resignFirstResponder()
    }
}
