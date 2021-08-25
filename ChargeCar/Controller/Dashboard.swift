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
        
        for i in Global.shared.confirmedBookings {
            print("Confirmed Bookings: \(i)")
        }
        
        //Check why blank row is created?\
        //Get text to fill entire row
        
        //Download all bookstarttime1 etc bookendtime1 etc
        self.ref.observeSingleEvent(of: .value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
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
        bookingTable.delegate = self
        bookingTable.dataSource = self
        bookingTable.tableFooterView = UIView()
    }

    //In the dashboard table, display bookings array value in table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.shared.confirmedBookings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tableView.register(UINib(nibName: "YourCellXibName", bundle: nil), forCellReuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = Global.shared.confirmedBookings[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
