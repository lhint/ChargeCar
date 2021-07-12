//
//  RealTimeDatabaseRetrieve.swift
//  ChargeCar
//
//  Created by Luke Hinton on 10/07/2021.
//

import Foundation
import Firebase

class realtimeDatabase {
    
    func retriveData(child: String) -> [String] {
        
        var emailValue = [""]
        var ref: DatabaseReference!
        ref = Database.database(url: "https://chargecar-2a276-default-rtdb.europe-west1.firebasedatabase.app/").reference()

        ref.child("email").getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                emailValue = snapshot.value as? [String] ?? [""]
            }
            else {
                print("No data available")
            }
        }
        return emailValue
    }
    //Brings back data from the data base
    
}
