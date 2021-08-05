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
    var signinUserEmail: String = ""
    var newSaveEmail: Bool = false
    var userUid: String = "none"
    var userReg: String = ""
    var databaseURL: String = "https://chargecar-2a276-default-rtdb.europe-west1.firebasedatabase.app/"
    var returnedChargerName: String = ""
    var returnedChargerLat: String = ""
    var returnedChargerLong: String = ""
    var currentLat: String = ""
    var currentLong: String = ""
    var privateChargerName: String = ""
    var privateChargerConnector: String = ""
    var privateChargerKWH: String = ""
    var privateChargerPrice: String = ""
    public static let shared = Global()
}
