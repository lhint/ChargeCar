//
//  Book.swift
//  ChargeCar
//
//  Created by Luke Hinton on 11/08/2021.
//

import UIKit
import SVProgressHUD

class Book: UIViewController {
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startTimeSlider: UISlider!
    @IBOutlet weak var endTimeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        
        //Set start and end time from Global parameters.
        //Set to timer.
    }
    
    @IBAction func book(_ sender: Any) {
        //When time is chosen save to db as userStartTime1 & userEndTime1, up the number programticly for bookings
        //Create a user alert variable made up of the username, userStart & userEnd time booked. Save to firebase - download from firebase and save to the global bookings array.
        //In the dashboard table display bookings array value in table.
        //Add if statement to homeViewController to check the booked time and gray out green booking for that time.
        //Validate that if that time, or any of the choosen time presents a UIAlert and stops them booking it.
        //Can only book a week at a time.
    }
    
}
