//
//  ViewController.swift
//  ChargeCar
//
//  Created by Luke Hinton on 04/03/2021.
//

import UIKit
import MapKit
import SVProgressHUD
import SideMenu
import Firebase

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    //Map Outlet to view controller component
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var publicChargerToggle: UISwitch!
    
    
    let defaults = UserDefaults.standard
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    let register = Register()
    var retrivedEmail = ""
    var signedInUsername = ""
    var privateCharger = [PrivateChargers]()
    var scheduledDays = [String : String]()
    var hostCharger: Bool = false
    var privateHostUid = ""
    
    var name1 = "", name2 = "", name3 = "", name4 = "", name5 = ""
    var bookedStartTime1 = "", bookedEndTime1 = ""
    var bookedStartTime2 = "", bookedEndTime2 = ""
    var bookedStartTime3 = "", bookedEndTime3 = ""
    var bookedStartTime4 = "", bookedEndTime4 = ""
    var bookedStartTime5 = "", bookedEndTime5 = ""
    var databaseInit = true
    
    //Global variables
    public var lat = 0.0, long = 0.0
    
    //Data to load on startup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mapview code from https://developer.apple.com/
        self.mapView.delegate = self
        mapView.register(
            MarkerView.self,
            forAnnotationViewWithReuseIdentifier:
                MKMapViewDefaultAnnotationViewReuseIdentifier)
        //Called functions
        currentLocation()
        Global.shared.signedIn = defaults.bool(forKey: "SignedIn")
        Global.shared.newSaveEmail = defaults.bool(forKey: "NewSaveEmail")
        Global.shared.bookings.removeAll()
        
        if Global.shared.newSaveEmail == true {
            Global.shared.signinUserEmail = defaults.string(forKey: "signedinUserEmail") ?? "none"
        }
        
        //Logging in user and collect info
        let user = Auth.auth().currentUser
        if let user = user {
            Global.shared.userUid = user.uid
            Global.shared.userEmail = user.email!
            print("Uid: \(Global.shared.userUid)")
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
            }
        }
        
        //Return signed in user details
        if Global.shared.signedIn == true {
            //Add chargers to map
            self.callAllPrivateChargers()
            let _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.addPrivateChargerToMap), userInfo: nil, repeats: false)
            Global.shared.confirmedBookings.removeAll()
            Global.shared.bookings.removeAll()
            
            //Retrive data from database
            DispatchQueue.global(qos: .default).async {
                
                let group = DispatchGroup()
                
                group.enter()
                
                self.ref.child("\(Global.shared.userUid)").child("email").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    
                    if snapshot.exists() {
                        
                        Global.shared.userEmail = snapshot.value as? String ?? ""
                        print("Email \(Global.shared.userEmail)")
                        
                    } else {
                        print("Error")
                        
                    }
                })
                //Get username for signed in user to display in menu
                self.ref.child("\(Global.shared.userUid)").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    //Get name value
                    var value = ""
                    
                    if snapshot.exists() {
                        
                        value = snapshot.value as? String ?? ""
                        print("Username: \(value)")
                        Global.shared.username = value
                        
                    } else {
                        print("Error")
                        
                    }
                })
                
                //Get car reg
                self.ref.child("\(Global.shared.userUid)").child("carreg").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    var value = ""
                    
                    if snapshot.exists() {
                        
                        value = snapshot.value as? String ?? ""
                        print("Carreg: \(value)")
                        Global.shared.userReg = value
                        
                    } else {
                        print("Error")
                        
                    }
                })
                
                //Get charger name
                self.ref.child("\(Global.shared.userUid)").child("chargername").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.exists() {
                        
                        Global.shared.returnedChargerName = snapshot.value as? String ?? ""
                        print("Charger Name: \(Global.shared.returnedChargerName)")
                        
                    } else {
                        Global.shared.returnedChargerName = ""
                        
                    }
                })
                
                //Get cooridnate latitude
                self.ref.child("\(Global.shared.userUid)").child("chargerlat").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    if snapshot.exists() {
                        
                        Global.shared.returnedChargerLat = snapshot.value as? String ?? ""
                        print("Charger Lat: \(Global.shared.returnedChargerLat)")
                        
                    } else {
                        Global.shared.returnedChargerLat = ""
                    }
                })
                
                //Get coordinate longitude
                self.ref.child("\(Global.shared.userUid)").child("chargerlong").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    
                    if snapshot.exists() {
                        
                        Global.shared.returnedChargerLong = snapshot.value as? String ?? ""
                        print("Charger Long: \(Global.shared.returnedChargerLong)")
                        
                    } else {
                        Global.shared.returnedChargerLong = ""
                    }
                })
                
                self.ref.child("\(Global.shared.userUid)").child("free").observeSingleEvent(of: .value, with: { (snapshot) in
                    //Get item value

                    if snapshot.exists() {
                        
                        Global.shared.userFree = snapshot.value as? String ?? ""
                        
                    } else {
                        Global.shared.userFree = "false"
                        
                    }
                })
                
                self.ref.child("\(Global.shared.userUid)").child("chargerconnector").observeSingleEvent(of: .value, with: { (snapshot) in
                    //Get item value
                    
                    if snapshot.exists() {
                        
                        Global.shared.userConnector = snapshot.value as? String ?? ""
                        
                    } else {
                        Global.shared.userConnector = ""
                        
                    }
                })
                
                self.ref.child("\(Global.shared.userUid)").child("chargerpowerkwh").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    
                    if snapshot.exists() {
                        
                        Global.shared.userKWH = snapshot.value as? String ?? ""
                        
                    } else {
                        Global.shared.userKWH = ""
                        
                    }
                })
                
                group.leave()
                
                group.wait()
                
                DispatchQueue.main.async {
                    
                }
                
            }
            
            //Get user email address to check if created
//            print("Saved user email from sign in screen: \(Global.shared.signinUserEmail)")
//            print("User email: \(Global.shared.userEmail)")
//            print("User name: \(Global.shared.username)")
            
            if Global.shared.signinUserEmail == Global.shared.userEmail {
                
            } else {
                
                //Saves details to database saving against current users uid
                self.ref.child("\(Global.shared.userUid)").setValue(["carreg": "\(Global.shared.userReg)","name": "\(Global.shared.username)","email": "\(Global.shared.userEmail)","uid": "\(Global.shared.userUid)"])
                if Global.shared.newSaveEmail == true {
                    //print("Email on home: \(Global.shared.userEmail)")
                    Global.shared.signinUserEmail = Global.shared.userEmail
                    self.defaults.set(Global.shared.signinUserEmail, forKey: "signedinUserEmail")
                }
            }
        }
    } //End of viewDidLoad
    
    //Hides navigation bar at the top of screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //Will show navigation bar at the top of the screen on the next view controller
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Runs on every screen appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Global.shared.confirmedBookings.removeAll()
        Global.shared.bookings.removeAll()
        callAllPrivateuidForThisHost()
        if self.databaseInit == true {
            let _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(callAllPrivateBookingsForThisHost), userInfo: nil, repeats: false)
            let _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(bookingStillAlive), userInfo: nil, repeats: false)
            Global.shared.confirmedBookings.removeAll()
            let _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(callAllPrivateBookingsForThisHost), userInfo: nil, repeats: false)
            let _ = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(dashboardString), userInfo: nil, repeats: false)
            self.databaseInit = false
        } else {
            Global.shared.confirmedBookings.removeAll()
            let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callAllPrivateBookingsForThisHost), userInfo: nil, repeats: false)
            let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(dashboardString), userInfo: nil, repeats: false)
        }
    }
    
    
    //Array to store returned public charger information
    var publicCharger = [PublicChargers]()
    
    //Finds the users current gps location
    func currentLocation() {
        let getLocation = GetLocation()
        getLocation.run {
            if let location = $0 {
                //print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
                
                self.lat = location.coordinate.latitude
                Global.shared.currentLat = String(self.lat)
                self.long = location.coordinate.longitude
                Global.shared.currentLong = String(self.long)
                print("current location Lat: \(self.lat) and Long: \(self.long)")
                // Set initial location - https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started
                let initialLocation = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
                //self.mapView.centerToLocation(initialLocation)
                //Zoom to user location found at: https://stackoverflow.com/questions/41189147/mapkit-zoom-to-user-current-location
                let viewRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 20000, longitudinalMeters: 20000)
                self.mapView.setRegion(viewRegion, animated: false)
                self.mapView.showsUserLocation = true
                SVProgressHUD.show()
                self.findPublicChargers(lat: self.lat, long: self.long)
                if self.publicChargerToggle.isOn {
                    let _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.publicChargersOnMap), userInfo: nil, repeats: false)
                }
            } else {
                print("Get Location failed \(String(describing: getLocation.didFailWithError))")
            }
        }
    }
    
    //Find scrolled map location
    func scrolledLocation(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        //print("\(center.latitude) + \(center.longitude)")
        self.lat = center.latitude
        self.long = center.longitude
    }
    
    //Find public chargers from local coordinates
    func findPublicChargers(lat: Double, long: Double) {
        //Use apiurl to pull all charge points that are currently in that area by adding lat and long into the api call &latitude=***&longitude=*****
        let apiurl = "https://api.openchargemap.io/api/v3/poi/?output=json&countrycode=UK&maxresults=100&compact=true&verbose=false"
        let apikey = "60cd63a9-e806-4e86-93ef-e8b460cf2e87"
        let urlString = "\(apiurl)&latitude=\(lat)&longitude=\(long)&key=\(apikey)"
        //print(urlString)
        performRequest(urlString: urlString)
        
    }
    
    //Perform API Request - (London App Brewry code: https://www.londonappbrewery.com/)
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            //print("Called")
            //Create a URL Session
            let session = URLSession(configuration: .default)
            //Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(data: safeData)
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    //Parse the JSON and use data that is needed following the data strcuture in PubicChargerData.swift file
    func parseJSON(data: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([PublicCharger].self, from: data)
            if !decodedData.isEmpty {
                
                let count = 0...10
                for i in count {
                    
                    var statusType1 = decodedData[i].AddressInfo.CountryID
                    var statusType2 = decodedData[i].AddressInfo.CountryID
                    var chargerConnector1 = decodedData[i].AddressInfo.CountryID
                    var chargerConnector2 = decodedData[i].AddressInfo.CountryID
                    var chargerKW1 = decodedData[i].AddressInfo.CountryID
                    var chargerKW2 = decodedData[i].AddressInfo.CountryID
                    
                    if decodedData[i].Connections.count == 0  {
                        statusType1 = decodedData[i].AddressInfo.CountryID
                        statusType2 = decodedData[i].AddressInfo.CountryID
                        chargerConnector1 = decodedData[i].AddressInfo.CountryID
                        chargerConnector2 = decodedData[i].AddressInfo.CountryID
                        chargerKW1 = decodedData[i].AddressInfo.CountryID
                        chargerKW2 = decodedData[i].AddressInfo.CountryID
                        
                    } else if decodedData[i].Connections.count == 1 {
                        statusType1 = decodedData[i].Connections[0].StatusTypeID ?? 0
                        statusType2 = decodedData[i].AddressInfo.CountryID
                        chargerConnector1 = decodedData[i].Connections[0].ConnectionTypeID ?? 0
                        chargerConnector2 = decodedData[i].AddressInfo.CountryID
                        chargerKW1 = decodedData[i].Connections[0].PowerKW ?? 0
                        chargerKW2 = decodedData[i].AddressInfo.CountryID
                    } else if decodedData[i].Connections.count == 2 {
                        statusType1 = decodedData[i].Connections[0].StatusTypeID ?? 0
                        statusType2 = decodedData[i].Connections[1].StatusTypeID ?? 0
                        chargerConnector1 = decodedData[i].Connections[0].ConnectionTypeID ?? 0
                        chargerConnector2 = decodedData[i].Connections[1].ConnectionTypeID ?? 0
                        chargerKW1 = decodedData[i].Connections[0].PowerKW ?? 0
                        chargerKW2 = decodedData[i].Connections[1].PowerKW ?? 0
                    } else {
                        statusType1 = decodedData[i].Connections[0].StatusTypeID ?? 0
                        statusType2 = decodedData[i].Connections[1].StatusTypeID ?? 0
                        chargerConnector1 = decodedData[i].Connections[0].ConnectionTypeID ?? 0
                        chargerConnector2 = decodedData[i].Connections[1].ConnectionTypeID ?? 0
                        chargerKW1 = decodedData[i].Connections[0].PowerKW ?? 0
                        chargerKW2 = decodedData[i].Connections[1].PowerKW ?? 0
                    }
                    
                    //Add the charger data as PublicCharger object to the publicCharger array
                    let charger = PublicChargers(publicChargerTitle: decodedData[i].AddressInfo.Title, publicChargerLatitude: decodedData[i].AddressInfo.Latitude, publicChargerLongitude: decodedData[i].AddressInfo.Longitude, publicChargerStatus1: statusType1, publicChargerStatus2: statusType2, publicChargerConnector1: chargerConnector1, publicChargerConnector2: chargerConnector2 , publicChargerKW1: chargerKW1, publicChargerKW2: chargerKW2, publicChargerFee1: decodedData[i].UsageCost ?? "")
                    publicCharger.append(charger)
                    
                }
            } else {
                print("Empty result!")
            }
        } catch {
            print("Error!: \(error)")
        }
    }
    
    //Updates the charger data everytime the user navigates the map
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Toggle Value: \(publicChargerToggle.isOn)")
        if publicChargerToggle.isOn {
            SVProgressHUD.show()
            scrolledLocation(mapView: mapView , regionDidChangeAnimated: true)
            self.findPublicChargers(lat: self.lat, long: self.long)
            let _ = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.publicChargersOnMap), userInfo: nil, repeats: false)
            publicChargerToggle.isEnabled = false
            let _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(reenableToggle), userInfo: nil, repeats: false)
            
            SVProgressHUD.dismiss()
        }
        
    }
    
    //Enables the private toogle button at the bottom of the home screen after data change
    @objc func reenableToggle() {
        publicChargerToggle.isEnabled = true
    }
    
    //Test that the api data is being stored into the array
//    func test() {
//        for element in publicCharger {
//            print("Chargers")
//            print(element.publicChargerTitle)
//            print(element.publicChargerLatitude)
//            print(element.publicChargerLongitude)
//            print(element.publicChargerStatus1)
//            print(element.publicChargerStatus2)
//            print(element.publicChargerConnector1)
//            print(element.publicChargerConnector2)
//            print(element.publicChargerKW1)
//            print(element.publicChargerKW2)
//            print(element.publicChargerFee1)
//        }
//    }
    
    //Add public chargers to map
    @objc func publicChargersOnMap() {
        print("Lat: \(self.lat) & Long: \(self.long)")
        //test()
            //Adds public chargers to map
        for element in publicCharger {
            let charger = Charger(
                title: element.publicChargerTitle,
                locationName: element.publicChargerTitle,
                coordinate: CLLocationCoordinate2D(latitude: element.publicChargerLatitude, longitude: element.publicChargerLongitude),
                chargerStatus1: element.publicChargerStatus1,
                chargerStatus2: element.publicChargerStatus2,
                chargerConnector1: element.publicChargerConnector1,
                chargerConnector2: element.publicChargerConnector2,
                chargerKW1: element.publicChargerKW1,
                chargerKW2: element.publicChargerKW2,
                chargerFee1: element.publicChargerFee1)
            mapView.addAnnotation(charger)
        }
        //Dismisses on screen loading circle
        SVProgressHUD.dismiss()
    }
    
    //Code from: https://stackoverflow.com/questions/51091590/swift-storyboard-creating-a-segue-in-mapview-using-calloutaccessorycontroltapp
    //Setup map view
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotationTitle = view.annotation?.title else
        {
            print("Unable to retrieve details")
            return
        }
        print("User tapped on annotation with title: \(annotationTitle!)")
        
        
        //Passes information to charger info screen when annotation is clicked
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chargerInfo = storyBoard.instantiateViewController(withIdentifier: "ChargerInfo") as! ChargerInfo
        let annotation = view.annotation as? Charger
        let privateAnnotation = view.annotation as? PrivateChargerMap
        chargerInfo.name = annotationTitle!
        chargerInfo.s1 = annotation?.chargerStatus1 ?? 0
        chargerInfo.c1 = annotation?.chargerConnector1 ?? 0
        chargerInfo.k1 = annotation?.chargerKW1 ?? 0
        chargerInfo.s2 = annotation?.chargerStatus2 ?? 0
        chargerInfo.c2 = annotation?.chargerConnector2 ?? 0
        chargerInfo.k2 = annotation?.chargerKW2 ?? 0
        chargerInfo.f1 = annotation?.chargerFee1 ?? ""
        chargerInfo.privateName = privateAnnotation?.title ?? ""
        chargerInfo.privateConnector = privateAnnotation?.chargerConnector1 ?? ""
        chargerInfo.privateKW = privateAnnotation?.chargerKW1 ?? ""
        chargerInfo.price = privateAnnotation?.price ?? "0.00"
        chargerInfo.privateHostUid = privateAnnotation?.hostUid ?? ""
        Global.shared.tempHostUid = privateAnnotation?.hostUid ?? ""
        Global.shared.hostUid = privateAnnotation?.hostUid ?? ""
        chargerInfo.free = privateAnnotation?.free ?? ""
//        print("PRIVTE ANOTATION")
//        print("temphostID: \(Global.shared.tempHostUid)")
//        print(privateAnnotation?.free ?? "")
//        print("PrivateHostUid: \(chargerInfo.privateHostUid)")
        navigationController?.pushViewController(chargerInfo, animated: true)
        
    }
    
    //Add private chargers to map
    @objc func addPrivateChargerToMap() {
        for each in privateCharger {
            let lat = each.chargerLat ?? ""
            //print(lat)
            let latconvert = Double(lat) ?? 0.0
            let long = each.chargerLong ?? ""
            //print(long)
            let longconvert = Double(long) ?? 0.0
            self.addPrivateCharger(chargerName: each.chargerName ?? "", coordinateLat: latconvert, coordinateLong: longconvert,chargerConnector: each.chargerConnector ?? "", chargerKWh: each.chargerPowerKwh ?? "", price: each.price ?? "0.00", hostUid: each.hostUid ?? "", free: each.free ?? "")
            print(each.chargerName ?? "", each.chargerLat ?? 0.0, each.chargerLong ?? 0.0, each.free ?? "")
            
        }
    }
    
    //Retrives all private charger information from database
    func callAllPrivateChargers() {
        
        self.ref.observeSingleEvent(of: .value) { (snapshot) in
            
            //Retrives data from the database
            for child in snapshot.children {
                self.scheduledDays.removeAll()
                let snap = child as! DataSnapshot
                let chargerName = snap.childSnapshot(forPath: "chargername").value as? String
                let chargerLat = snap.childSnapshot(forPath: "chargerlat").value as? String
                let chargerLong = snap.childSnapshot(forPath: "chargerlong").value as? String
                let chargerConnector = snap.childSnapshot(forPath: "chargerconnector").value as? String
                let chargerPowerKwh = snap.childSnapshot(forPath: "chargerpowerkwh").value as? String
                let price = snap.childSnapshot(forPath: "price").value as? String
                let mondayCharger = snap.childSnapshot(forPath: "mondayshare").value as? String
                let tuesdayCharger = snap.childSnapshot(forPath: "tuesdayshare").value as? String
                let wednesdayCharger = snap.childSnapshot(forPath: "wednesdayshare").value as? String
                let thursdayCharger = snap.childSnapshot(forPath: "thursdayshare").value as? String
                let fridayCharger = snap.childSnapshot(forPath: "fridayshare").value as? String
                let saturdayCharger = snap.childSnapshot(forPath: "saturdayshare").value as? String
                let sundayCharger = snap.childSnapshot(forPath: "sundayshare").value as? String
                Global.shared.mondayStart = snap.childSnapshot(forPath: "mondaystart").value as? String ?? ""
                Global.shared.mondayEnd = snap.childSnapshot(forPath: "mondayend").value as? String ?? ""
                Global.shared.tuesdayStart = snap.childSnapshot(forPath: "tuesdaystart").value as? String ?? ""
                Global.shared.tuesdayEnd = snap.childSnapshot(forPath: "tuesdayend").value as? String ?? ""
                Global.shared.wednesdayStart = snap.childSnapshot(forPath: "wednesdaystart").value as? String ?? ""
                Global.shared.wednesdayEnd = snap.childSnapshot(forPath: "wednesdayend").value as? String ?? ""
                Global.shared.thursdayStart = snap.childSnapshot(forPath: "thursdaystart").value as? String ?? ""
                Global.shared.thursdayEnd = snap.childSnapshot(forPath: "thursdayend").value as? String ?? ""
                Global.shared.fridayStart = snap.childSnapshot(forPath: "fridaystart").value as? String ?? ""
                Global.shared.fridayEnd = snap.childSnapshot(forPath: "fridayend").value as? String ?? ""
                Global.shared.saturdayStart = snap.childSnapshot(forPath: "saturdaystart").value as? String ?? ""
                Global.shared.saturdayEnd = snap.childSnapshot(forPath: "saturdayend").value as? String ?? ""
                Global.shared.sundayStart = snap.childSnapshot(forPath: "sundaystart").value as? String ?? ""
                Global.shared.sundayEnd = snap.childSnapshot(forPath: "sundayend").value as? String ?? ""
                Global.shared.shareChargerOverride = snap.childSnapshot(forPath: "sharechargeroverride").value as? String ?? ""
                Global.shared.hostUid = snap.childSnapshot(forPath: "uid").value as? String ?? ""
                Global.shared.free = snap.childSnapshot(forPath: "free").value as? String ?? ""
                //print("HostUid: \(Global.shared.hostUid)")
                
                //Stores local schedule day toggle values from database information
                if ((mondayCharger?.contains("true")) != nil) {
                    self.scheduledDays.updateValue("\(mondayCharger ?? "false")", forKey: "Monday")
                    Global.shared.mondayCharger = mondayCharger ?? "false"
                } else {
                    self.scheduledDays.updateValue("\(mondayCharger ?? "false")", forKey: "Monday")
                    Global.shared.mondayCharger = mondayCharger ?? "false"
                }
                if ((tuesdayCharger?.contains("true")) != nil) {
                    self.scheduledDays.updateValue("\(tuesdayCharger ?? "false")", forKey: "Tuesday")
                    Global.shared.tuesdayCharger = tuesdayCharger ?? "false"
                } else {
                    self.scheduledDays.updateValue("\(tuesdayCharger ?? "false")", forKey: "Tuesday")
                    Global.shared.tuesdayCharger = tuesdayCharger ?? "false"
                }
                if ((wednesdayCharger?.contains("true")) != nil) {
                    //self.scheduledDays.append("\(wednesdayCharger ?? "false")")
                    Global.shared.wednesdayCharger = wednesdayCharger ?? "false"
                } else {
                    self.scheduledDays.updateValue("\(wednesdayCharger ?? "false")", forKey: "Wednesday")
                    Global.shared.wednesdayCharger = wednesdayCharger ?? "false"
                }
                if ((thursdayCharger?.contains("true")) != nil) {
                    //self.scheduledDays.append("\(thursdayCharger ?? "false")")
                    Global.shared.thursdayCharger = thursdayCharger ?? "false"
                } else {
                    self.scheduledDays.updateValue("\(thursdayCharger ?? "false")", forKey: "Thursday")
                    Global.shared.thursdayCharger = thursdayCharger ?? "false"
                }
                if ((fridayCharger?.contains("true")) != nil) {
                    //self.scheduledDays.append("\(fridayCharger ?? "false")")
                    print("Friday Charger Value: \(fridayCharger ?? "None")")
                    Global.shared.fridayCharger = fridayCharger ?? "false"
                } else {
                    self.scheduledDays.updateValue("\(fridayCharger ?? "false")", forKey: "Friday")
                    Global.shared.fridayCharger = fridayCharger ?? "false"
                }
                if ((saturdayCharger?.contains("true")) != nil) {
                    //self.scheduledDays.append("\(saturdayCharger ?? "false")")
                    Global.shared.saturdayCharger = saturdayCharger ?? "false"
                } else {
                    self.scheduledDays.updateValue("\(saturdayCharger ?? "false")", forKey: "Saturday")
                    Global.shared.saturdayCharger = saturdayCharger ?? "false"
                }
                if ((sundayCharger?.contains("true")) != nil) {
                    //self.scheduledDays.append("\(sundayCharger ?? "false")")
                    Global.shared.sundayCharger = sundayCharger ?? "false"
                } else {
                    self.scheduledDays.updateValue("\(sundayCharger ?? "false")", forKey: "Sunday")
                    Global.shared.sundayCharger = sundayCharger ?? "false"
                }
                
                
                if Global.shared.shareChargerOverride.contains("false") {
                    //print("override false: \(override ?? "none")")
                } else {
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat  = "EEEE" // "EE" to get short style
                    let dayInWeek = dateFormatter.string(from: date)
                    
                    //Get current time
                    let now = Date()
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone.current
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    formatter.timeStyle = .short
                    let currentTime = formatter.string(from: now)
                    print("Date: \(dayInWeek) Time: \(currentTime)")
                    //Schedule date check
                    if dayInWeek == "Monday" {
                        print("Monday Showing")
                        print("MondayStartTime \(Global.shared.mondayStart)")
                        print("MondayEndTime \(Global.shared.mondayEnd)")
                        //Schedule time check
                        if currentTime >= Global.shared.mondayStart && Global.shared.mondayCharger.contains("true") {
                            //print("MondayTimeWorking")
                            let custom = PrivateChargers(chargerName: chargerName, chargerLat: chargerLat, chargerLong: chargerLong, chargerConnector: chargerConnector ?? "", chargerPowerKwh: chargerPowerKwh ?? "", price: price ?? "0.00", hostUid: Global.shared.hostUid, free: Global.shared.free)
                            self.privateCharger.append(custom)
                            print(Global.shared.hostUid)
                        }
                    } else if dayInWeek == "Tuesday" && Global.shared.tuesdayCharger.contains("true") {
                        //print("Tuesday Showing")
                        //print("TuesdayStartTime \(Global.shared.tuesdayStart)")
                        //print("TuesdayEndTime \(Global.shared.tuesdayEnd)")
                        if currentTime > Global.shared.tuesdayStart && currentTime < Global.shared.tuesdayEnd {
                            let custom = PrivateChargers(chargerName: chargerName, chargerLat: chargerLat, chargerLong: chargerLong, chargerConnector: chargerConnector ?? "", chargerPowerKwh: chargerPowerKwh ?? "", price: price ?? "0.00", hostUid: Global.shared.hostUid, free: Global.shared.free)
                            self.privateCharger.append(custom)
                        }
                    } else if dayInWeek == "Wednesday" && Global.shared.wednesdayCharger.contains("true"){
                        print("Wednesday Showing")
                        if currentTime > Global.shared.wednesdayStart && currentTime < Global.shared.wednesdayEnd {
                            let custom = PrivateChargers(chargerName: chargerName, chargerLat: chargerLat, chargerLong: chargerLong, chargerConnector: chargerConnector ?? "", chargerPowerKwh: chargerPowerKwh ?? "", price: price ?? "0.00", hostUid: Global.shared.hostUid, free: Global.shared.free)
                            self.privateCharger.append(custom)
                        }
                    } else if dayInWeek == "Thursday" && Global.shared.thursdayCharger.contains("true") {
                        print("Thursday Showing")
                        if currentTime > Global.shared.thursdayStart && currentTime < Global.shared.thursdayEnd {
                            let custom = PrivateChargers(chargerName: chargerName, chargerLat: chargerLat, chargerLong: chargerLong, chargerConnector: chargerConnector ?? "", chargerPowerKwh: chargerPowerKwh ?? "", price: price ?? "0.00", hostUid: Global.shared.hostUid, free: Global.shared.free)
                            self.privateCharger.append(custom)
                        }
                    } else if dayInWeek == "Friday" && Global.shared.fridayCharger.contains("true") {
                        print("Friday Showing")
                        if currentTime > Global.shared.fridayStart && currentTime < Global.shared.fridayEnd {
                            let custom = PrivateChargers(chargerName: chargerName, chargerLat: chargerLat, chargerLong: chargerLong, chargerConnector: chargerConnector ?? "", chargerPowerKwh: chargerPowerKwh ?? "", price: price ?? "0.00", hostUid: Global.shared.hostUid, free: Global.shared.free)
                            self.privateCharger.append(custom)
                        }
                    } else if dayInWeek == "Saturday" {
                        print("Saturday Showing")
                        if currentTime > Global.shared.saturdayStart && Global.shared.saturdayCharger.contains("true") {
                            let custom = PrivateChargers(chargerName: chargerName, chargerLat: chargerLat, chargerLong: chargerLong, chargerConnector: chargerConnector ?? "", chargerPowerKwh: chargerPowerKwh ?? "", price: price ?? "0.00", hostUid: Global.shared.hostUid, free: Global.shared.free)
                            self.privateCharger.append(custom)
                        }
                    } else if dayInWeek == "Sunday" {
                        print("Sunday Showing")
                        if currentTime > Global.shared.sundayStart && Global.shared.sundayCharger.contains("true") {
                            let custom = PrivateChargers(chargerName: chargerName, chargerLat: chargerLat, chargerLong: chargerLong, chargerConnector: chargerConnector ?? "", chargerPowerKwh: chargerPowerKwh ?? "", price: price ?? "0.00", hostUid: Global.shared.hostUid, free: Global.shared.free)
                            self.privateCharger.append(custom)
                        }
                    }
                }
            }
        }
        let _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.addPrivateChargerToMap), userInfo: nil, repeats: false)
    }
    
    //Add private charger annotations to the map
    func addPrivateCharger(chargerName: String, coordinateLat: Double, coordinateLong: Double, chargerConnector: String, chargerKWh: String, price: String, hostUid: String, free: String) {
        
        let privateChargerAnnotation = PrivateChargerMap(chargerName: chargerName, coordinate: CLLocationCoordinate2D(latitude: coordinateLat,  longitude: coordinateLong), chargerConnector1: chargerConnector, chargerKW1: chargerKWh, price: price, hostUid: hostUid, free: free )
        mapView.addAnnotation(privateChargerAnnotation)
        print(chargerName, coordinateLat, coordinateLong)
        for i in Global.shared.bookings {
            print("Bookings Days: \(i)")
        }
    }
    
    //Gets all bookings for this host
    func callAllPrivateuidForThisHost() {
        
        //Download all booker UID's stored within the hosts UID.
        DispatchQueue.global(qos: .default).async {
            
            let group = DispatchGroup()
            
            group.enter()
            
            self.ref.child("\(Global.shared.userUid)").child("bookinguseruid1").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    Global.shared.bookinguid1 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            if Global.shared.userUid.contains("") {
                
                self.ref.child("\(Global.shared.userUid)").child("hostuid1").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.exists() {
                        
                        Global.shared.hostUid1 = snapshot.value as? String ?? ""
                        
                    } else {
                        print("Error")
                        
                    }
                })
                
            }
            
            self.ref.child("\(Global.shared.userUid)").child("bookinguseruid2").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    Global.shared.bookinguid2 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookinguseruid3").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    Global.shared.bookinguid3 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookinguseruid4").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.exists() {
                    
                    Global.shared.bookinguid4 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookinguseruid5").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    Global.shared.bookinguid5 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            group.leave()
            
            group.wait()
            
            DispatchQueue.main.async {
                
            }
            
        }
    }
    
    //Gets host bookings for the signed in host
    @objc func callAllPrivateBookingsForThisHost() {
        
        DispatchQueue.global(qos: .default).async {
        
            let group = DispatchGroup()
            
            group.enter()
            
            //Get usernames for each UID
            
            if Global.shared.bookinguid1.isEmpty {
                
            } else {
                
                self.ref.child("\(Global.shared.bookinguid1)").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    if snapshot.exists() {
                        
                        self.name1 = snapshot.value as? String ?? ""
                        
                    } else {
                        print("Error")
                        
                    }
                })
                
            }
            
            if Global.shared.bookinguid2.isEmpty {
                
            } else {
                
                
                self.ref.child("\(Global.shared.bookinguid2)").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    if snapshot.exists() {
                        
                        self.name2 = snapshot.value as? String ?? ""
                        
                    } else {
                        print("Error")
                        
                    }
                })
                
            }
            
            if Global.shared.bookinguid3.isEmpty {
                
            } else {
                
                self.ref.child("\(Global.shared.bookinguid3)").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    if snapshot.exists() {
                        
                        self.name3 = snapshot.value as? String ?? ""
                        
                    } else {
                        print("Error")
                        
                    }
                })
            }
            
            if Global.shared.bookinguid4.isEmpty {
                
            } else {
                
                self.ref.child("\(Global.shared.bookinguid4)").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    if snapshot.exists() {
                        
                        self.name4 = snapshot.value as? String ?? ""
                        
                    } else {
                        print("Error")
                        
                    }
                })
            }
            
            if Global.shared.bookinguid5.isEmpty {
                
            } else {
                
                self.ref.child("\(Global.shared.bookinguid5)").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    if snapshot.exists() {
                        
                        self.name5 = snapshot.value as? String ?? ""
                        
                    } else {
                        print("Error")
                        
                    }
                })
            }
            
            
            self.ref.child("\(Global.shared.userUid)").child("bookingdatestamp1").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    Global.shared.bookingDateStamp1 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookingdatestamp2").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    Global.shared.bookingDateStamp2 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookingdatestamp3").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    Global.shared.bookingDateStamp3 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookingdatestamp4").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    Global.shared.bookingDateStamp4 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookingdatestamp5").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    Global.shared.bookingDateStamp5 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedStartTime1").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedStartTime1 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedEndTime1").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedEndTime1 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedStartTime2").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedStartTime2 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedEndTime2").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedEndTime2 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedStartTime3").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedStartTime3 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedEndTime3").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedEndTime3 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedStartTime4").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedStartTime4 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedEndTime4").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedEndTime4 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedStartTime5").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedStartTime5 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            self.ref.child("\(Global.shared.userUid)").child("bookedEndTime5").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item value
                if snapshot.exists() {
                    
                    self.bookedEndTime5 = snapshot.value as? String ?? ""
                    
                } else {
                    print("Error")
                    
                }
            })
            
            
            print("user uid: \(Global.shared.userUid)")
            print("booking1 userID: \(Global.shared.bookinguid1)")
            
            group.leave()
            
            group.wait()
        
            DispatchQueue.main.async {
                
            }
            
        }
    }
    
    //Checks if the booking is still in date or its removed.
    @objc func bookingStillAlive() {
        
        let setDate = String(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: setDate)
        
        if Global.shared.bookingDateStamp1.isEmpty {
        } else {
            
            let bookingTimeStamp1 = dateFormatter.date(from: Global.shared.bookingDateStamp1)!
            if date! > bookingTimeStamp1 {
                print("CurrentDate: \(String(describing: date))")
                print("stillAliveBookingTimeStamp1: \(bookingTimeStamp1)")
                print("PrivateChargerUid \(Global.shared.userUid)")
                self.ref.child(Global.shared.userUid).updateChildValues(["bookedStartTime1":"","bookedEndTime1":"","bookingdatestamp1":"","bookinguseruid1":""])
                Global.shared.confirmedBookings.removeAll()
            } else {
                
            }
        }
        
        if Global.shared.bookingDateStamp2.isEmpty {
        } else {
            let bookingTimeStamp2 = dateFormatter.date(from: Global.shared.bookingDateStamp2)!
            
            if date! > bookingTimeStamp2 {
                print("CurrentDate: \(String(describing: date))")
                print("stillAliveBookingTimeStamp2: \(bookingTimeStamp2)")
                print("PrivateChargerUid \(Global.shared.userUid)")
                self.ref.child(Global.shared.userUid).updateChildValues(["bookedStartTime2":"","bookedEndTime2":"","bookingdatestamp2":"","bookinguseruid2":""])
                Global.shared.confirmedBookings.removeAll()
            } else {
                
            }
        }
        
        if Global.shared.bookingDateStamp3.isEmpty {
        } else {
            
            let bookingTimeStamp3 = dateFormatter.date(from: Global.shared.bookingDateStamp3)!
            
            if date! > bookingTimeStamp3 {
                print("CurrentDate: \(String(describing: date))")
                print("stillAliveBookingTimeStamp3: \(bookingTimeStamp3)")
                print("PrivateChargerUid \(Global.shared.userUid)")
                self.ref.child(Global.shared.userUid).updateChildValues(["bookedStartTime3":"","bookedEndTime3":"","bookingdatestamp3":"","bookinguseruid3":""])
                Global.shared.confirmedBookings.removeAll()
            } else {
                
            }
        }
        
        if Global.shared.bookingDateStamp4.isEmpty {
        } else {
            let bookingTimeStamp4 = dateFormatter.date(from: Global.shared.bookingDateStamp4)!
            if date! > bookingTimeStamp4 {
                print("CurrentDate: \(String(describing: date))")
                print("stillAliveBookingTimeStamp1: \(bookingTimeStamp4)")
                print("PrivateChargerUid \(Global.shared.userUid)")
                self.ref.child(Global.shared.userUid).updateChildValues(["bookedStartTime4":"","bookedEndTime4":"","bookingdatestamp4":"","bookinguseruid4":""])
                Global.shared.confirmedBookings.removeAll()
            } else {
                
            }
        }
        
        if Global.shared.bookingDateStamp5.isEmpty {
        } else {
            let bookingTimeStamp5 = dateFormatter.date(from: Global.shared.bookingDateStamp5)!
            if date! > bookingTimeStamp5 {
                print("CurrentDate: \(String(describing: date))")
                print("stillAliveBookingTimeStamp1: \(bookingTimeStamp5)")
                print("PrivateChargerUid \(Global.shared.userUid)")
                self.ref.child(Global.shared.userUid).updateChildValues(["bookedStartTime5":"","bookedEndTime5":"","bookingdatestamp5":"","bookinguseruid5":""])
                Global.shared.confirmedBookings.removeAll()
            } else {
                
            }
        }
    }
    
    //Creates a string out of the booked user data. This string is then added to an array and read by the dashboard table view
    @objc func dashboardString() {
        
        print("name1: \(self.name1)")
        print("BookingDateStamp1: \(Global.shared.bookingDateStamp1)")
        
        if Global.shared.bookingDateStamp1.isEmpty {
            
        } else {
            Global.shared.confirmedBookings.append("\(self.name1) has booked for \(getDayOfWeek(date: Global.shared.bookingDateStamp1)) on \(Global.shared.bookingDateStamp1) starting at: \(bookedStartTime1) and ending at: \(bookedEndTime1)")
        }
        if Global.shared.bookingDateStamp2.isEmpty {
            
        } else {
            Global.shared.confirmedBookings.append("\(self.name2) has booked for \(getDayOfWeek(date: Global.shared.bookingDateStamp2)) on \(Global.shared.bookingDateStamp2) starting at: \(bookedStartTime2) and ending at: \(bookedEndTime2)")
        }
        if Global.shared.bookingDateStamp3.isEmpty {
            
        } else {
            Global.shared.confirmedBookings.append("\(self.name3) has booked for \(getDayOfWeek(date: Global.shared.bookingDateStamp3)) on \(Global.shared.bookingDateStamp3) starting at: \(bookedStartTime3) and ending at: \(bookedEndTime3)")
        }
        if Global.shared.bookingDateStamp4.isEmpty {
            
        } else {
            Global.shared.confirmedBookings.append("\(self.name4) has booked for \(getDayOfWeek(date: Global.shared.bookingDateStamp4)) on \(Global.shared.bookingDateStamp4) starting at: \(bookedStartTime4) and ending at: \(bookedEndTime4)")
        }
        if Global.shared.bookingDateStamp5.isEmpty {
            
        } else {
            Global.shared.confirmedBookings.append("\(self.name5) has booked for \(getDayOfWeek(date: Global.shared.bookingDateStamp5)) on \(Global.shared.bookingDateStamp5) starting at: \(bookedStartTime5) and ending at: \(bookedEndTime5)")
        }
    }
    
    //Update view method
    @IBAction func updateView(_ sender: Any) {
        privateCharger.removeAll()
        Global.shared.bookings.removeAll()
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        if Global.shared.signedIn == true {
            self.callAllPrivateChargers()
        }
    }
    
    //Recenters the user to their current location on UI location button press
    @IBAction func relocate(_ sender: Any) {
        currentLocation()
    }
    
    //Gets the date for the day of week selected
    func getDayOfWeek(date: String) -> String {
        //Inspired from: https://stackoverflow.com/questions/24089999/how-do-you-create-a-swift-date-object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let convertedDate = dateFormatter.date(from:date) ?? Date(timeIntervalSinceReferenceDate: -123456789.0) // Feb 2, 1997, 10:26 AM
        
        dateFormatter.dateFormat = "EEEE"
        let day = dateFormatter.string(from: convertedDate)
        print(dateFormatter.string(from: convertedDate))
        return day
    }
    
    //Refreshes the view on UI button refresh button press
    @IBAction func publicChargerToggleRefresh(_ sender: Any) {
        privateCharger.removeAll()
        Global.shared.bookings.removeAll()
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        if publicChargerToggle.isOn {
            self.callAllPrivateChargers()
        }
        if Global.shared.signedIn == true {
            self.callAllPrivateChargers()
        }
        SVProgressHUD.dismiss()
    }
}

//Extension for map location data
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
