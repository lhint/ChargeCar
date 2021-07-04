//
//  Menu.swift
//  ChargeCar
//
//  Created by Luke Hinton on 29/06/2021.
//

import UIKit

class Menu: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Charge Car"
    }
    
    var menu1: [String] = ["Login", "Register"]
    var menu2: [String] = ["Host","Help","Account","Sign Out"]
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menu1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = menu1[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.textLabel?.text == "Register" {
            self.performSegue(withIdentifier: "register", sender: nil)
        } else if cell?.textLabel?.text == "Login" {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
