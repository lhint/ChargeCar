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
    
    let defaults = UserDefaults.standard
    let ref = Database.database(url: "\(Global.shared.databaseURL)").reference()
    let register = Register()
    var retrivedEmail = ""
    var signedInUsername = ""
    var privateCharger = [PrivateChargers]()
    
    //Global veriables
    public var lat = 0.0, long = 0.0
    
    //viewdidload - To load at startup
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
        
        if Global.shared.newSaveEmail == true {
        Global.shared.signinUserEmail = defaults.string(forKey: "signedinUserEmail") ?? "none"
        }
        //Global.shared.signinUserEmail = defaults.string(forKey: "signedinUserEmail") ?? ""
        
        //Get current logged in user data
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            Global.shared.userUid = user.uid
            Global.shared.userEmail = user.email!
            print("Uid: \(Global.shared.userUid)")
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
                
            }
        }
        
        // Return signed in user details
        if Global.shared.signedIn == true {
            self.callAllPrivateChargers()
            let _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.addPrivateChargerToMap), userInfo: nil, repeats: false)
            
            DispatchQueue.global(qos: .default).async {

              // 2
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
                     // Get item value
                  var value = ""

                     if snapshot.exists() {

                         value = snapshot.value as? String ?? ""
                         print("Username: \(value)")
                         Global.shared.username = value
                         
                     } else {
                         print("Error")

                     }
                 })
                
                //get car reg
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
                        print("Error")
                        
                    }
                })
                
                //Get cooridnate latitude
                self.ref.child("\(Global.shared.userUid)").child("chargerlat").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    if snapshot.exists() {
                        
                        Global.shared.returnedChargerLat = snapshot.value as? String ?? ""
                        print("Charger Lat: \(Global.shared.returnedChargerLat)")
                        
                    } else {
                        print("Error")
                        
                    }
                })
                
                //get coordinate longitude
                self.ref.child("\(Global.shared.userUid)").child("chargerlong").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get item value
                    
                    if snapshot.exists() {
                        
                        Global.shared.returnedChargerLong = snapshot.value as? String ?? ""
                        print("Charger Long: \(Global.shared.returnedChargerLong)")
                        
                    } else {
                        print("Error")
                        
                    }
                })
                
                group.leave()
                
                group.wait()

              // 6
              DispatchQueue.main.async {
    
              }

            }
            
            //Get user email address to check if created
            
            print("Saved user email from sign in screen: \(Global.shared.signinUserEmail)")
            print("User email: \(Global.shared.userEmail)")
            print("User name: \(Global.shared.username)")
            
            if Global.shared.signinUserEmail == Global.shared.userEmail {
                
            } else {
                
                //saves details to database saving against current users uid
                self.ref.child("\(Global.shared.userUid)").setValue(["carreg": "\(Global.shared.userReg)","name": "\(Global.shared.username)","email": "\(Global.shared.userEmail)","uid": "\(Global.shared.userUid)"])
                if Global.shared.newSaveEmail == true {
                    print("Email on home: \(Global.shared.userEmail)")
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
                let _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.publicChargersOnMap), userInfo: nil, repeats: false)
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
    
    //Perform API Request - (London App Brewry code)
    
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
    
    //parse the JSON and use data that is needed
    func parseJSON(data: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([PublicCharger].self, from: data)
            if !decodedData.isEmpty {
                //print("Ran")
                //print("Data: \(decodedData[0].AddressInfo.Title)")
                
                
                let count = 0...10
                for i in count {
                    //print("Connections: \(decodedData[i].Connections.count)")
                    
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
        SVProgressHUD.show()
        scrolledLocation(mapView: mapView , regionDidChangeAnimated: true)
        self.findPublicChargers(lat: self.lat, long: self.long)
        let _ = Timer.scheduledTimer(timeInterval: 7.0, target: self, selector: #selector(self.publicChargersOnMap), userInfo: nil, repeats: false)
    }
    
    //Test that the api data is being stored into the array
    func test() {
        for element in publicCharger {
            print("Chargers")
            print(element.publicChargerTitle)
            print(element.publicChargerLatitude)
            print(element.publicChargerLongitude)
            print(element.publicChargerStatus1)
            print(element.publicChargerStatus2)
            print(element.publicChargerConnector1)
            print(element.publicChargerConnector2)
            print(element.publicChargerKW1)
            print(element.publicChargerKW2)
            print(element.publicChargerFee1)
        }
    }
    
    //Add public chargers to map
    
    @objc func publicChargersOnMap() {
        //If scrolled location == 0 use current location
        print("Lat: \(self.lat) & Long: \(self.long)")
        //test()
        
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
        
        SVProgressHUD.dismiss()
    }
    
    //Code from: https://stackoverflow.com/questions/51091590/swift-storyboard-creating-a-segue-in-mapview-using-calloutaccessorycontroltapp
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotationTitle = view.annotation?.title else
        {
            print("Unable to retrieve details")
            return
        }
        print("User tapped on annotation with title: \(annotationTitle!)")

        
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
        navigationController?.pushViewController(chargerInfo, animated: true)
    
    }
    
    
    @objc func addPrivateChargerToMap() {
        for each in privateCharger {
            let lat = each.chargerLat ?? ""
            //print(lat)
            let latconvert = Double(lat) ?? 0.0
            let long = each.chargerLong ?? ""
            //print(long)
            let longconvert = Double(long) ?? 0.0
            self.addPrivateCharger(chargerName: each.chargerName ?? "", coordinateLat: latconvert, coordinateLong: longconvert,chargerConnector: each.chargerConnector ?? "", chargerKWh: each.chargerPowerKwh ?? "", price: each.price ?? "0.00")
            print(each.chargerName ?? "", each.chargerLat ?? 0.0, each.chargerLong ?? 0.0)
            
        }
    }
    
    
    func callAllPrivateChargers() {

        self.ref.observeSingleEvent(of: .value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let chargerName = snap.childSnapshot(forPath: "chargername").value as? String
                let chargerLat = snap.childSnapshot(forPath: "chargerlat").value as? String
                let chargerLong = snap.childSnapshot(forPath: "chargerlong").value as? String
                let chargerConnector = snap.childSnapshot(forPath: "chargerconnector").value as? String
                let chargerPowerKwh = snap.childSnapshot(forPath: "chargerpowerkwh").value as? String
                let price = snap.childSnapshot(forPath: "price").value as? String
                let hostCharger = snap.childSnapshot(forPath: "showCharger").value as? Bool
                if hostCharger == true {
                let custom = PrivateChargers(chargerName: chargerName, chargerLat: chargerLat, chargerLong: chargerLong, chargerConnector: chargerConnector ?? "", chargerPowerKwh: chargerPowerKwh ?? "", price: price ?? "0.00")
                self.privateCharger.append(custom)
                }
            }
        }
    }
    
    func addPrivateCharger(chargerName: String, coordinateLat: Double, coordinateLong: Double, chargerConnector: String, chargerKWh: String, price: String) {
        
        let privateChargerAnnotation = PrivateChargerMap(chargerName: chargerName, coordinate: CLLocationCoordinate2D(latitude: coordinateLat,  longitude: coordinateLong), chargerConnector1: chargerConnector, chargerKW1: chargerKWh, price: price )
        mapView.addAnnotation(privateChargerAnnotation)
        print(chargerName, coordinateLat, coordinateLong)
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
