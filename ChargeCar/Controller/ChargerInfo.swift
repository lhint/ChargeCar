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
    public var s1 = 0.0
    public var c1 = 0.0
    public var k1 = 0.0
    public var s2 = 0.0
    public var c2 = 0.0
    public var k2 = 0.0
    
    
    override func viewDidLoad() {
            
        
        self.title = name
        self.status1.text = checkKey(value: s1)
        self.connector1.text = checkKey(value: c1)
        self.kw1.text = kwCheck(kw: k1)
        self.status2.text = checkKey(value: s2)
        self.connector2.text = checkKey(value: c2)
        self.kw2.text = kwCheck(kw: k2)
        
    }
    
    func checkKey(value: Double) -> String {
        var answer = ""
        if value == 25 {
            answer = "Type 2"
        } else if value == 50 {
            answer = "Operational"
        } else if value == 2 {
            answer = "CHAdeMO"
        } else if value == 1036 {
            answer = "CHAdeMO"
        } else if value == 0 {
            answer = "Restricted"
        } else if value == 75 {
            answer = "Partly Operational"
        } else if value == 100 {
            answer = "Not Operational"
        }
        return answer
    }
    
    func kwCheck(kw: Double) -> String {
        
        var answer = ""
        
        if kw > 1.0 {
             let convert = Int(kw)
            answer = String(convert)
        } else if kw == 1.0
        {
            answer = ""
        }
        return answer
    }
    
    //Figure out if null can be added in place where no Connections array is given - Create an array with custom type
    //Create a function that converts status connector and KW into the string that the value represents
}
