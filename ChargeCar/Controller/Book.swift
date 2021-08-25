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
    @IBOutlet weak var bookButton: UIButton!
    
    
    fileprivate let pickerView = ToolbarPickerView()
    fileprivate let titles = Global.shared.bookings //Replace with set host days
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    var privateHostUid = Global.shared.hostUid
    var startTimeDay = ""
    var endTimeDay = ""
    var bookingStart1 = "", bookingEnd1 = ""
    var bookingStart2 = "", bookingEnd2 = ""
    var bookingStart3 = "", bookingEnd3 = ""
    var bookingStart4 = "", bookingEnd4 = ""
    var totalBookings = 0
    var selectedStartTime = ""
    var selectedEndTime = ""
    var bookedDay = ""
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        callhostDateStamps()
        
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
        self.selectDay.text = Global.shared.bookings.first
        dayCheck(day: Global.shared.bookings.first ?? "")
        startTimeField.placeholder = Global.shared.hostStartTimeDay
        endTimeField.placeholder = Global.shared.hostEndTimeDay
        
    }
    
    func validateBooking() {
        
    if selectDay.text! == self.selectDay.text! || startTimeField.text! == self.selectedStartTime || endTimeField.text! == self.selectedEndTime {
        let alert = UIAlertController(title: "Whoops...", message: "Please select a start and end time.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    } else {
        
    }
    
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
        self.selectedStartTime = time
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
        var bookingNumber = 1
        print("datestamps \(Global.shared.hostBookingDateStamp1) -  \(Global.shared.hostBookingDateStamp2)  -  \(Global.shared.hostBookingDateStamp3) - \(Global.shared.hostBookingDateStamp4)  -  \(Global.shared.hostBookingDateStamp5)")
        if Global.shared.hostBookingDateStamp1.isEmpty  {
            self.bookingStart1 = start
            self.bookingEnd1 = end
            bookingNumber = 1
        } else if Global.shared.hostBookingDateStamp2.isEmpty {
            self.bookingStart2 = start
            self.bookingEnd2 = end
            bookingNumber = 2
        } else if Global.shared.hostBookingDateStamp3.isEmpty {
            self.bookingStart3 = start
            self.bookingEnd3 = end
            bookingNumber = 3
        } else if Global.shared.hostBookingDateStamp4.isEmpty {
            self.bookingStart4 = start
            self.bookingEnd4 = end
            bookingNumber = 4
        } else if Global.shared.hostBookingDateStamp5.isEmpty {
            self.bookingStart4 = start
            self.bookingEnd4 = end
           bookingNumber = 5
        } else {
            let alert = UIAlertController(title: "Limit Reached", message: "There is currently no avilable bookings with this host!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true)
        }
        return bookingNumber
    }
    
    func createDateStampName(bookingNumber: Int) -> String {
        var output = ""
        if bookingNumber == 1 {
            output = "bookingDateStamp1"
        } else if bookingNumber == 2 {
            output = "bookingDateStamp2"
        } else if bookingNumber == 3 {
            output = "bookingDateStamp3"
        } else if bookingNumber == 4 {
            output = "bookingDateStamp4"
        } else if bookingNumber == 5 {
            output = "bookingDateStamp5"
        }
        return "\(output)"
    }
    
    @IBAction func book(_ sender: Any) {
        
        bookedDay = selectDay.text ?? ""
        print("BookedDay: \(bookedDay)")
        
        Global.shared.chosenDate = setFutureDate(chosenDay: selectDay.text!)
        
        print("SetFutureDate \(setFutureDate(chosenDay: selectDay.text!))")
        validateBooking()
        
        if  selectedStartTime > selectedEndTime || alreadyBooked() {
            
            if selectedStartTime > selectedEndTime {
                let alert = UIAlertController(title: "Whoops...", message: "Booking start time cannot exceed booking end time!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                present(alert, animated: true)
                
            } else {
                let alert = UIAlertController(title: "Already Booked", message: "This date is already booked!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                present(alert, animated: true)
            }
           
            } else {
                self.ref.child(Global.shared.tempHostUid).updateChildValues(["bookedStartTime\(allocateBookings(start: selectedStartTime, end: selectedEndTime))": "\(selectedStartTime)","totalbookings" : "\(totalBookings)", "bookedEndTime\(allocateBookings(start: selectedStartTime, end: selectedEndTime))": "\(selectedEndTime)", "bookinguseruid\(allocateBookings(start: selectedStartTime, end: selectedEndTime))" : "\(Global.shared.userUid)", "bookingdatestamp\(allocateBookings(start: selectedStartTime, end: selectedEndTime))" : "\(Global.shared.chosenDate)", "hostuid\(allocateBookings(start: selectedStartTime, end: selectedEndTime))" : self.privateHostUid])
            }
        
        callhostDateStamps()
        
        totalBookings = totalBookings + 1
        
        //UI Alert to confirm booking
        let alert = UIAlertController(title: "Booked", message: "You have now booked. Start time: \(self.selectedStartTime), End time: \(self.selectedEndTime)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            self.startTimeField.text = ""
            self.endTimeField.text = ""
            self.selectDay.text = ""
            
        }))
        present(alert, animated: true)
        
        
        //Add if statement to homeViewController to check the booked time and gray out green booking for that time.
        
        //Check trello notes
        //When booking finishes clear start and end times (check this works in if statement)
        //Create text to display booking info for dashboard and save to confirmed bookings array - How to save this to the database? Store locally and then do a check to see if the booking still exists?
        
    }
    
    
    
    func alreadyBooked() -> Bool {
        print("TEMPHOSTUID")
        print(Global.shared.tempHostUid)
        print("BookedDay: \(bookedDay)")
        
        print("getDayOfWeek1:")
        print(getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp1)"))
        print("getDayOfWeek2:")
        print(getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp2)"))
        print("getDayOfWeek3:")
        print(getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp3)"))
        print("getDayOfWeek4:")
        print(getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp4)"))
        print("getDayOfWeek5:")
        print(getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp5)"))
        print("END")
        
        
        if Global.shared.hostBookingDateStamp1.isEmpty {
            return false
        } else {
            
            if getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp1)") == bookedDay {
                
                return true
            }
        }
        
        if Global.shared.hostBookingDateStamp2.isEmpty {
            return false
        } else {
            if getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp2)") == bookedDay {
                return true
            }
        }
        
        if Global.shared.hostBookingDateStamp3.isEmpty {
            return false
        } else {
    
            if getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp3)") == bookedDay {
                return true
            }
        }
        
        if Global.shared.hostBookingDateStamp4.isEmpty {
            return false
        } else {
            
            if getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp4)") == bookedDay {
                return true
            }
        }
        if Global.shared.hostBookingDateStamp5.isEmpty {
            return false
        } else {
            
            if getDayOfWeek(date: "\(Global.shared.hostBookingDateStamp5)")  == bookedDay {
                return true
            }
        }
        return false
    }
    
    //Works out date for future selected days
    func setFutureDate(chosenDay: String) -> String {
        let setDate = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from:setDate)!
        print("Todays Date: \(setDate)")
        let thisDay = getDayOfWeek(date: "\(setDate)")
        print("Todays day is \(thisDay)")
        
        var dayDelta = 0
        
        switch thisDay {
        
        case "Monday":
            print("Monday selected")
           // dayDeltaCheck(day: "Monday")
            dayDelta = dayDeltaCheck(chosenDay: chosenDay, day: thisDay, dayDeltaStart: 0)
        case "Tuesday":
            print("Tuesday selected")
            dayDelta = dayDeltaCheck(chosenDay: chosenDay, day: thisDay, dayDeltaStart: 6)
        case "Wednesday":
            print("Wednesday selected")
            dayDelta = dayDeltaCheck(chosenDay: chosenDay, day: thisDay, dayDeltaStart: 5)
        case "Thursday":
            print("Thursday selected")
            dayDelta = dayDeltaCheck(chosenDay: chosenDay, day: thisDay, dayDeltaStart: 4)
        case "Friday":
            print("Friday selected")
            dayDelta = dayDeltaCheck(chosenDay: chosenDay, day: thisDay, dayDeltaStart: 3)
        case "Saturday":
            print("Saturday selected")
            dayDelta = dayDeltaCheck(chosenDay: chosenDay, day: thisDay, dayDeltaStart: 2)
        case "Sunday":
            print("Sunday selected")
            dayDelta = dayDeltaCheck(chosenDay: chosenDay, day: thisDay, dayDeltaStart: 1)
        default:
            print("No date")
        }
        let newDate =  date.addingTimeInterval(60*60*24*Double(dayDelta))
        let newDateFormatted = dateFormatter.string(from:newDate)
        print("newDateFormatted \(newDateFormatted)")
        print("dayDelta: \(dayDelta)")
        return "\(newDateFormatted)"
    }
    
    func dayDeltaCheck(chosenDay: String, day: String, dayDeltaStart: Int) -> Int {
        
        var dayDelta = 0
        if chosenDay.contains("Monday") {
            dayDelta = dayDeltaStart
        } else if chosenDay.contains("Tuesday") {
            dayDelta = dayDeltaStart + 1
        } else if chosenDay.contains("Wednesday") {
            dayDelta = dayDeltaStart + 2
        } else if chosenDay.contains("Thursday") {
            dayDelta = dayDeltaStart + 3
        } else if chosenDay.contains("Friday") {
            dayDelta = dayDeltaStart + 4
        } else if chosenDay.contains("Saturday") {
            dayDelta = dayDeltaStart + 5
        } else if chosenDay.contains("Sunday") {
            dayDelta = dayDeltaStart + 6
        }
        return dayDelta
    }
    
    func getDayOfWeek(date: String) -> String {
        //Inspired from: https://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let convertedDate = dateFormatter.date(from:date) ?? Date(timeIntervalSinceReferenceDate: -123456789.0) // Feb 2, 1997, 10:26 AM
        
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: convertedDate)
        print(dateFormatter.string(from: convertedDate))
        return day
    }
    
    func dayCheck(day: String) {
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
              
                if self.privateHostUid.isEmpty {
                    
                } else {
                
                    self.ref.child(self.privateHostUid).child("\(self.startTimeDay)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                        print("privateHostID: \(self.privateHostUid)")
                        print("StartTimeDay \(self.startTimeDay)")
                    
                    if snapshot.exists() {
                        
                        Global.shared.hostStartTimeDay = snapshot.value as? String ?? ""
                        self.startTimeField.placeholder = Global.shared.hostStartTimeDay
                    } else {
                        print("Error")
                        
                    }
                })
                
                    self.ref.child(self.privateHostUid).child("\(self.endTimeDay)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    
                    if snapshot.exists() {
                        
                        Global.shared.hostEndTimeDay = snapshot.value as? String ?? ""
                        self.endTimeField.placeholder = Global.shared.hostEndTimeDay
                        
                    } else {
                        print("Error")
                        
                    }
                })
                    
                }
            
                group.leave()
                
                group.wait()
                

              // 6
              DispatchQueue.main.async {
              }
            }
        }
}

func callhostDateStamps() {
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    DispatchQueue.global(qos: .default).async {
        
        // 2
        let group = DispatchGroup()
        
        group.enter()


        ref.child("\(Global.shared.tempHostUid )").child("bookingdatestamp1").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get item value
            if snapshot.exists() {

                Global.shared.hostBookingDateStamp1 = snapshot.value as? String ?? ""

            } else {
                print("Error")

            }
        })
            
        ref.child("\(Global.shared.tempHostUid )").child("bookingdatestamp2").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get item value
            if snapshot.exists() {

                Global.shared.hostBookingDateStamp2 = snapshot.value as? String ?? ""

            } else {
                print("Error")

            }
        })

        ref.child("\(Global.shared.tempHostUid )").child("bookingdatestamp3").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get item value
            if snapshot.exists() {

                Global.shared.hostBookingDateStamp3 = snapshot.value as? String ?? ""

            } else {
                print("Error")

            }
        })

        ref.child("\(Global.shared.tempHostUid )").child("bookingdatestamp4").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get item value
            if snapshot.exists() {

                Global.shared.hostBookingDateStamp4 = snapshot.value as? String ?? ""

            } else {
                print("Error")

            }
        })

        ref.child("\(Global.shared.tempHostUid)").child("bookingdatestamp5").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get item value
            if snapshot.exists() {

                Global.shared.hostBookingDateStamp5 = snapshot.value as? String ?? ""
                print("hostbookingdatestamp5fromdatabase \(Global.shared.hostBookingDateStamp5)")

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
