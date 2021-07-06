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
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        
        do {
            try firebaseAuth.signOut()
            Global.shared.signedIn = false
        } catch let signOutError as NSError {
            print("Error signing out", signOutError)
        }
    }
}
