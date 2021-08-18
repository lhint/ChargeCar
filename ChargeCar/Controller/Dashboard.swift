//
//  Dashboard.swift
//  ChargeCar
//
//  Created by Luke Hinton on 11/08/2021.
//

import UIKit
import SVProgressHUD
import Firebase

class Dashboard: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bookingTable: UITableView!
    
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    var bookingDay = ""
    var bookingStart1 = ""
    var bookingEnd1 = ""
    var bookingStart2 = ""
    var bookingEnd2 = ""
    var bookingStart3 = ""
    var bookingEnd3 = ""
    var bookingStart4 = ""
    var bookingEnd4 = ""
    var totalBookings = ""
    var bookinguid1 = ""
    var bookerUid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
        
        
        //Download all bookstarttime1 etc bookendtime1 etc
        self.ref.observeSingleEvent(of: .value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                self.bookingDay = snap.childSnapshot(forPath: "bookedday").value as? String ?? ""
                self.totalBookings = snap.childSnapshot(forPath: "totalbookings").value as? String ?? ""
                self.bookinguid1 = snap.childSnapshot(forPath: "totalbookings").value as? String ?? ""
                self.bookingStart1 = snap.childSnapshot(forPath: "bookingstart1").value as? String ?? ""
                self.bookingStart1 = snap.childSnapshot(forPath: "bookingstart1").value as? String ?? ""
                self.bookingEnd1 = snap.childSnapshot(forPath: "bookingend1").value as? String ?? ""
                self.bookingStart2 = snap.childSnapshot(forPath: "bookingstart2").value as? String ?? ""
                self.bookingEnd2 = snap.childSnapshot(forPath: "bookingend2").value as? String ?? ""
                self.bookingStart3 = snap.childSnapshot(forPath: "bookingstart3").value as? String ?? ""
                self.bookingEnd3 = snap.childSnapshot(forPath: "bookingend3").value as? String ?? ""
                self.bookingStart4 = snap.childSnapshot(forPath: "bookingstart4").value as? String ?? ""
                self.bookingEnd4 = snap.childSnapshot(forPath: "bookingstart1").value as? String ?? ""
                //Download private charger uid - work out how booking uid work?
                self.bookerUid = snap.childSnapshot(forPath: "uid").value as? String ?? ""
            }
        }
    }
    
    //Check uid against username and download
    func uidUserNameCheck() {
        
    }
    
    //Add this date to the string shown and save to Global.shared.bookings array
    //Create a string with username, userStart & userEnd time booked. Save to firebase - download from firebase and save to the global bookings array.
    func convertToStringAndSave() {
        
    }

    //In the dashboard table, display bookings array value in table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //let list = array[indexPath.row]
        //cell.textLabel?.text = list
        return cell
        
    }
}
