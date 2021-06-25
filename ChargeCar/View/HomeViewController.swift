//
//  ViewController.swift
//  ChargeCar
//
//  Created by Luke Hinton on 04/03/2021.
//

import UIKit
import MapKit
import SVProgressHUD

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    //Map Outlet to view controller component
    @IBOutlet weak var mapView: MKMapView!
    
    //public lat & long veriables
    public var lat = 0.0, long = 0.0
    
    //viewdidload - To load at startup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        mapView.register(
            MarkerView.self,
            forAnnotationViewWithReuseIdentifier:
                MKMapViewDefaultAnnotationViewReuseIdentifier)
        //End of imported code
        currentLocation()
    }//End of viewDidLoad
    
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
                self.long = location.coordinate.longitude
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
                    let charger = PublicChargers(publicChargerTitle: "\(decodedData[i].AddressInfo.Title)", publicChargerLatitude: decodedData[i].AddressInfo.Latitude, publicChargerLongitude: decodedData[i].AddressInfo.Longitude, publicChargerStatus1: decodedData[i].Connections[0].StatusTypeID, publicChargerStatus2: decodedData[i].Connections[0].StatusTypeID, publicChargerConnector1: decodedData[i].Connections[0].ConnectionTypeID, publicChargerConnector2: decodedData[i].Connections[0].ConnectionTypeID, publicChargerKW1: decodedData[i].Connections[0].PowerKW, publicChargerKW2: decodedData[i].Connections[0].PowerKW)
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
        }
    }
    
    //Add public chargers to map
    
    @objc func publicChargersOnMap() {
        //If scrolled location == 0 use current location
        print("Lat: \(self.lat) & Long: \(self.long)")
        test()
        
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
                    chargerKW2: element.publicChargerKW2)
                mapView.addAnnotation(charger)
            }
            
            SVProgressHUD.dismiss()
            //annotationView.markerTintColor = UIColor.blue (Change marker colours for my own chargers)
        }
    
    //Code from: https://stackoverflow.com/questions/51091590/swift-storyboard-creating-a-segue-in-mapview-using-calloutaccessorycontroltapp
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //performSegue(withIdentifier: "chargerInfo", sender: nil)
        
        guard let annotationTitle = view.annotation?.title else
        {
            print("Unable to retrieve details")
            return
        }
        print("User tapped on annotation with title: \(annotationTitle!)")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: "ChargerInfo") as! ChargerInfo
        let annotation = view.annotation as? Charger
        home.name = annotationTitle!
        home.s1 = annotation?.chargerStatus1 ?? 0
        home.c1 = annotation?.chargerConnector1 ?? 0
        home.k1 = annotation?.chargerKW1 ?? 0
        home.s2 = annotation?.chargerStatus2 ?? 0
        home.c2 = annotation?.chargerConnector2 ?? 0
        home.k2 = annotation?.chargerKW2 ?? 0
        navigationController?.pushViewController(home, animated: true)
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
