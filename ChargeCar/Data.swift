//
//  Data.swift
//  ChargeCar
//
//  Created by Luke Hinton on 04/03/2021.
//

import Foundation

struct PublicCharger: Decodable {
    let AddressInfo: AddressInfo
    
}

struct AddressInfo: Decodable {
    let Title: String
}









