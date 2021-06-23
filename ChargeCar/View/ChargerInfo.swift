//
//  ChargerInfo.swift
//  ChargeCar
//
//  Created by Luke Hinton on 20/06/2021.
//

import UIKit

class ChargerInfo: UIViewController {
    
    @IBOutlet weak var chargerTitle: UILabel!
    
    public var name = ""
    
    override func viewDidLoad() {
        self.title = name
    }
}
