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
    let publicChargerStatus1: Int
    let publicChargerStatus2: Int
    let publicChargerConnector1: Int
    let publicChargerConnector2: Int
    let publicChargerKW1: Int
    let publicChargerKW2: Int
    
    init(publicChargerTitle: String, publicChargerLatitude: Double, publicChargerLongitude: Double, publicChargerStatus1: Int, publicChargerStatus2: Int, publicChargerConnector1: Int, publicChargerConnector2: Int, publicChargerKW1: Int, publicChargerKW2: Int) {
        
        self.publicChargerTitle = publicChargerTitle
        self.publicChargerLatitude = publicChargerLatitude
        self.publicChargerLongitude = publicChargerLongitude
        self.publicChargerStatus1 = publicChargerStatus1
        self.publicChargerStatus2 = publicChargerStatus2
        self.publicChargerConnector1 = publicChargerConnector1
        self.publicChargerConnector2 = publicChargerConnector2
        self.publicChargerKW1 = publicChargerKW1
        self.publicChargerKW2 = publicChargerKW2
    }
}


