//
//  PrivateChargers.swift
//  ChargeCar
//
//  Created by Luke Hinton on 13/07/2021.
//

import UIKit

class PrivateChargers {
    var chargerName: String?
    var chargerLat: String?
    var chargerLong: String?
    var chargerConnector: String?
    var chargerPowerKwh: String?
    var price: String?
    var hostUid: String?
    var free: String?
    
    init( chargerName: String?,
          chargerLat: String?,
          chargerLong: String?,
          chargerConnector: String?,
          chargerPowerKwh: String?,
          price: String,
          hostUid: String,
          free: String)
    {
        self.chargerName = chargerName
        self.chargerLat = chargerLat
        self.chargerLong = chargerLong
        self.chargerConnector = chargerConnector
        self.chargerPowerKwh = chargerPowerKwh
        self.price = price
        self.hostUid = hostUid
        self.free = free
    }
}
