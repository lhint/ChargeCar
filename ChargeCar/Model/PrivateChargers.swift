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
    
    init( chargerName: String?,
          chargerLat: String?,
          chargerLong: String?)
    {
        self.chargerName = chargerName
        self.chargerLat = chargerLat
        self.chargerLong = chargerLong
    }
}
