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
            Global.shared.signinUserEmail = ""
            self.defaults.set("Global.shared.signedIn", forKey: "SignedIn")
            self.defaults.set(Global.shared.signinUserEmail, forKey: "signedinUserEmail")
            Global.shared.newSaveEmail = false
            self.defaults.set(Global.shared.newSaveEmail, forKey: "NewSaveEmail")
        } catch let signOutError as NSError {
            print("Error signing out", signOutError)
        }
    }
}
