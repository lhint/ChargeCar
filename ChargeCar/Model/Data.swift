//
//  Data.swift
//  ChargeCar
//
//  Created by Luke Hinton on 04/03/2021.
//

import Foundation

struct PublicCharger: Decodable {
    let AddressInfo: AddressInfo
    let Connections: [Connections]
}

struct AddressInfo: Decodable {
    let Title: String
    let Latitude: Double
    let Longitude: Double
    let CountryID: Double
}

struct Connections: Decodable {
    let StatusTypeID: Double?
    let ConnectionTypeID: Double?
    let PowerKW: Double?

}
