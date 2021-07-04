//
//  SignOut.swift
//  ChargeCar
//
//  Created by Luke Hinton on 04/07/2021.
//

import Foundation
import Firebase

class SignOut {
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Eror signing out", signOutError)
        }
    }
}
