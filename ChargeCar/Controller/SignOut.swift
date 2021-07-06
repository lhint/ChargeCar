//
//  SignOut.swift
//  ChargeCar
//
//  Created by Luke Hinton on 04/07/2021.
//

import Foundation
import Firebase

class SignOut {

    public static let shared = SignOut()
    let defaults = UserDefaults.standard
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            Global.shared.signedIn = false
            self.defaults.set(Global.shared.signedIn, forKey: "SignedIn")
        } catch let signOutError as NSError {
            print("Error signing out", signOutError)
        }
    }
}
