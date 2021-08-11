//
//  Dashboard.swift
//  ChargeCar
//
//  Created by Luke Hinton on 11/08/2021.
//

import UIKit
import SVProgressHUD

class Dashboard: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bookingTable: UITableView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //let list = array[indexPath.row]
        //cell.textLabel?.text = list
        return cell
        
    }
}
