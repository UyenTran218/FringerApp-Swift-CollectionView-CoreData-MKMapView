//
//  VenueLocationViewController.swift
//  FringeFestival
//
//  Created by Tran, Thi Khanh Uyen - traty145 on 22/10/20.
//  Copyright © 2020 Tran, Thi Khanh Uyen - traty145. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VenueLocationViewController: DetailViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    /// Ask user permission for location detecting
    ///
    /// - Parameter status: CLAuthorizationStatus
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            showLocationServicesDeniedAlert()
        case .restricted:
            showLocationServicesDeniedAlert()
        }
    }
    ////Show alert for location service
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLocationManager()
    }
    func setupLocationManager() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        self.handleLocationAuthorizationStatus(status: authorizationStatus)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways || status == .authorizedWhenInUse
        {
            manager.startUpdatingLocation()
        }
    }
    ////After update location, annotation displayed on map view with Event name
    ///
    /// - Parameters:
    ///   - manager: CLLocationManager
    ///   - locations: CLLocation array
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20
        
        var locationList = DataManager.sharedDataManager.venues
        for location in locationList {
            var pinLatitude = location.latitude
            var pinLongitude = location.longitude
            var locationPin = CLLocationCoordinate2D(latitude: pinLatitude, longitude: pinLongitude)
            let region = MKCoordinateRegion(center: locationPin, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)); self.mapView.setRegion(region, animated: true)
            let myAnnotation: MKPointAnnotation = MKPointAnnotation()
            myAnnotation.coordinate = CLLocationCoordinate2DMake(pinLatitude, pinLongitude)
            myAnnotation.title = DataManager.sharedDataManager.fromIdToName(venue: location)
            mapView.addAnnotation(myAnnotation)
        }
        
    }

    

}
