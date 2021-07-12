//
//  Global.swift
//  ChargeCar
//
//  Created by Luke Hinton on 06/07/2021.
//  Global variables to be access by all controllers
//

import Foundation

class Global {

    var signedIn: Bool = false
    var username: String = ""
    var userEmail: String = ""
    var userUid: String = "none"
    var userReg: String = ""
    public static let shared = Global()
}
