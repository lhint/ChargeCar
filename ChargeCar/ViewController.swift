//
//  ViewController.swift
//  ChargeCar
//
//  Created by Luke Hinton on 04/03/2021.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    public var lat = 0.0, long = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Get Lat and Long of location shown on map.
        //Code found at: https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
        currentLocation()
        //self.findPublicChargers(lat: self.lat, long: self.long)
        self.mapView.delegate = self
        
        //End of imported code
    }//End of viewDidLoad
    
    //Array to store public charger information
    
    var chargerTitle = [String](repeating: "", count: 10)
    var latitude = [Double]()
    var longitude = [Double]()
    
    //Finds the users current gps location
    func currentLocation() {
        let getLocation = GetLocation()
        getLocation.run {
            if let location = $0 {
                //print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
                self.lat = location.coordinate.latitude
                self.long = location.coordinate.longitude
                //print("\(self.lat) and \(self.long)")
                // Set initial location - https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started
                let initialLocation = CLLocation(latitude: self.lat, longitude: self.long)
                self.mapView.centerToLocation(initialLocation)
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
        let apiurl = "https://api.openchargemap.io/v3/poi/?output=json&countrycode=UK&maxresults=100&compact=true&verbose=false"
        let urlString = "\(apiurl)&latitude=\(lat)&longitude=\(long)"
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
                        chargerTitle[i] = decodedData[i].AddressInfo.Title
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
    
    //Add charge points to the map using a notation point.
    ////
    
    
    //Updates the charger data everytime the user navigates the map
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        scrolledLocation(mapView: mapView , regionDidChangeAnimated: true)
        self.findPublicChargers(lat: self.lat, long: self.long)
        
    }
    
    @IBAction func test(_ sender: Any) {
        for element in chargerTitle {
            print(element)
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
