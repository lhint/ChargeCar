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
    
    @IBOutlet weak var mapView: MKMapView!
    public var lat = 0.0, long = 0.0
    
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
    
    //Array to store returned public charger information
    
    var publicChargerTitle = [String]()
    var publicChargerLatitude = [Double]()
    var publicChargerLongitude = [Double]()
    
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
                self.findPublicChargers(lat: self.lat, long: self.long)
                SVProgressHUD.show()
                let _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(self.publicChargersOnMap), userInfo: nil, repeats: false)
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
    //Create the custom url
    
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
                        publicChargerTitle.append(decodedData[i].AddressInfo.Title)
                        publicChargerLatitude.append(decodedData[i].AddressInfo.Latitude)
                        publicChargerLongitude.append(decodedData[i].AddressInfo.Longitude)
                    }
                    //chargerTitle[0] = decodedData[0].AddressInfo.Title
                    //print("Data: \(decodedData[1].AddressInfo.Title)")
                    //chargerTitle[1] = decodedData[1].AddressInfo.Title
                    //Get Title/Latitude/Longitude of each charge point
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
    
    //Test that api data is being stored into the array
    func test() {
        for element in publicChargerTitle {
            print(element)
        }
        for element in publicChargerLongitude {
            print(element)
        }
        for element in publicChargerLatitude {
            print(element)
        }
  }
    
    //Add public chargers to map
    
    @objc func publicChargersOnMap() {
        //If scrolled location == 0 use current location
        print("Lat: \(self.lat) & Long: \(self.long)")
        
        //let count = 0...10
        for index in stride(from: 0, through: publicChargerTitle.count-1, by: 1) {
        let charger = Charger(
        title: "\(publicChargerTitle[index])",
        locationName: "\(publicChargerTitle[index])",
        coordinate: CLLocationCoordinate2D(latitude: publicChargerLatitude[index], longitude: publicChargerLongitude[index]))
        mapView.addAnnotation(charger)
        SVProgressHUD.dismiss()
        //annotationView.markerTintColor = UIColor.blue (Change marker colours for my own chargers)
        }
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

//Save each of the returned data to an array
//Use array to create MKAnnotations
