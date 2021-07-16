//
//  MarkerView.swift
//  ChargeCar
//
//  Created by Luke Hinton on 13/03/2021.
//

import MapKit

class MarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard (newValue as? Charger) != nil else {
                return
            }
            guard (newValue as? Charger) != nil else {
                return
            }
            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
    }
}
