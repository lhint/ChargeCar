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
    var hostUid: String = ""
    var mondayCharger: String = ""
    var tuesdayCharger: String = ""
    var wednesdayCharger: String = ""
    var thursdayCharger: String = ""
    var fridayCharger: String = ""
    var saturdayCharger: String = ""
    var sundayCharger: String = ""
    var mondayStart: String = ""
    var mondayEnd: String = ""
    var tuesdayStart: String = ""
    var tuesdayEnd: String = ""
    var wednesdayStart: String = ""
    var wednesdayEnd: String = ""
    var thursdayStart: String = ""
    var thursdayEnd: String = ""
    var fridayStart: String = ""
    var fridayEnd: String = ""
    var saturdayStart: String = ""
    var saturdayEnd: String = ""
    var sundayStart: String = ""
    var sundayEnd: String = ""
    var shareChargerOverride = ""
    var userMondayShare: String = ""
    var userTuesdayShare: String = ""
    var userWednesdayShare: String = ""
    var userThursdayShare: String = ""
    var userFridayShare: String = ""
    var userSaturdayShare: String = ""
    var userSundayShare: String = ""
    var free: String = ""
    var bookings: Array = [String]()
    var confirmedBookings: Array = [String]()
    var hostStartTimeDay: String = ""
    var hostEndTimeDay: String = ""
    var hostSelectedDay: String = ""
    var bookinguid1: String = ""
    var bookinguid2: String = ""
    var bookinguid3: String = ""
    var bookinguid4: String = ""
    var bookinguid5: String = ""
    var bookingDateStamp1 = "", bookingDateStamp2 = "", bookingDateStamp3 = "", bookingDateStamp4 = "", bookingDateStamp5 = ""
    var hostUid1 = "", hostUid2 = "", hostUid3 = "", hostUid4 = "", hostUid5 = ""
    var tempHostUid = ""
    var chosenDate: String = ""
    var hostBookingDateStamp1 = "", hostBookingDateStamp2 = "", hostBookingDateStamp3 = "", hostBookingDateStamp4 = "", hostBookingDateStamp5 = ""
    var userFree: String = ""
    var userConnector: String = ""
    var userKWH: String = ""
    public static let shared = Global()
}
