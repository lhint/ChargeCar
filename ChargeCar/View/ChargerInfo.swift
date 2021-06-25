//
//  ChargerInfo.swift
//  ChargeCar
//
//  Created by Luke Hinton on 20/06/2021.
//

import UIKit

class ChargerInfo: UIViewController {
    
    @IBOutlet weak var status1: UILabel!
    @IBOutlet weak var connector1: UILabel!
    @IBOutlet weak var kw1: UILabel!
    @IBOutlet weak var status2: UILabel!
    @IBOutlet weak var connector2: UILabel!
    @IBOutlet weak var kw2: UILabel!
    
    
    
    public var name = ""
    public var s1 = 0
    public var c1 = 0
    public var k1 = 0
    public var s2 = 0
    public var c2 = 0
    public var k2 = 0
    
    
    override func viewDidLoad() {
        self.title = name
        self.status1.text = "\(s1)"
        self.connector1.text = "\(c1)"
        self.kw1.text = "\(k1)"
        self.status2.text = "\(s1)"
        self.connector2.text = "\(c2)"
        self.kw2.text = "\(k2)"
        
    }
    
    //Figure out if null can be added in place where no Connections array is given - Create an array with custom type
    //Create a function that converts status connector and KW into the string that the value represents
}
