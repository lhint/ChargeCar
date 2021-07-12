//
//  Menu.swift
//  ChargeCar
//
//  Created by Luke Hinton on 29/06/2021.
//

import UIKit
import Firebase

class Menu: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Charge Car"
    }
    
    var menu1: [String] = ["Login", "Register"]
    var menu2: [String] = ["\(Global.shared.username)","Host","Help","Sign Out"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var total = 0
        if Global.shared.signedIn == false {
           total = self.menu1.count
        } else if Global.shared.signedIn == true {
           total = self.menu2.count
        }
        return total
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if Global.shared.signedIn == false {
        cell.textLabel?.text = menu1[indexPath.row]
        } else if Global.shared.signedIn == true {
            cell.textLabel?.text = menu2[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
            let cell = tableView.cellForRow(at: indexPath)
            if cell?.textLabel?.text == "Register" {
                self.performSegue(withIdentifier: "register", sender: nil)
            } else if cell?.textLabel?.text == "Login" {
                self.performSegue(withIdentifier: "login", sender: nil)
            } else if cell?.textLabel?.text == "Sign Out" {
                SignOut.shared.signOut()
                self.performSegue(withIdentifier: "returnHome", sender: nil)
            } else if cell?.textLabel?.text == "\(Global.shared.username)" {
                self.performSegue(withIdentifier: "account", sender: nil)
            } else if cell?.textLabel?.text == "Help" {
                self.performSegue(withIdentifier: "help", sender: nil)
            } else if cell?.textLabel?.text == "Host" {
                self.performSegue(withIdentifier: "host", sender: nil)
            }
    }
}
