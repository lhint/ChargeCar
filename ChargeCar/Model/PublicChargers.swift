//
//  PublicChargers.swift
//  ChargeCar
//
//  Created by Luke Hinton on 19/06/2021.
//

import Foundation

class PublicChargers {
    
    let publicChargerTitle: String
    let publicChargerLatitude: Double
    let publicChargerLongitude: Double
    let publicChargerStatus1: Double
    let publicChargerStatus2: Double
    let publicChargerConnector1: Double
    let publicChargerConnector2: Double
    let publicChargerKW1: Double
    let publicChargerKW2: Double
    let publicChargerFee1: String
    
    init(publicChargerTitle: String,
         publicChargerLatitude: Double,
         publicChargerLongitude: Double,
         publicChargerStatus1: Double,
         publicChargerStatus2: Double,
         publicChargerConnector1: Double,
         publicChargerConnector2: Double,
         publicChargerKW1: Double,
         publicChargerKW2: Double,
         publicChargerFee1: String) {
        
        self.publicChargerTitle = publicChargerTitle
        self.publicChargerLatitude = publicChargerLatitude
        self.publicChargerLongitude = publicChargerLongitude
        self.publicChargerStatus1 = publicChargerStatus1
        self.publicChargerStatus2 = publicChargerStatus2
        self.publicChargerConnector1 = publicChargerConnector1
        self.publicChargerConnector2 = publicChargerConnector2
        self.publicChargerKW1 = publicChargerKW1
        self.publicChargerKW2 = publicChargerKW2
        self.publicChargerFee1 = publicChargerFee1
    }
}


