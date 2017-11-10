//
//  ViewController.swift
//  alwaysLocationTest
//
//  Created by MacBook Air on 10/11/17.
//  Copyright © 2017 Desarrollo Software. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        print("\(CLLocationManager.authorizationStatus())")
        
            
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
                print("ALWAYS")
                locationManager.delegate = self
                locationManager.distanceFilter = kCLDistanceFilterNone
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                print("\(locationManager.location)")
            
            }
            else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            print("WHEN USE")
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("\(locationManager.location)")
            locationManager.requestAlwaysAuthorization()}
            
            else if CLLocationManager.authorizationStatus() == .denied{
            print("DENIED")
            locationManager.requestAlwaysAuthorization()}
            else {
            print("NO")
            locationManager.requestAlwaysAuthorization()}
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            print("viewDidAppear ALWAYS")
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("\(locationManager.location)")
            
        }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            print("viewDidAppear WHEN USE")
            alertLocation()
        }
            
        else if CLLocationManager.authorizationStatus() == .denied{
            print("viewDidAppear DENIED")
            alertLocation()
    
        }
        else {
            print("viewDidAppear NO")
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            print("didUpdateLocations ALWAYS")
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("\(locationManager.location)")
            
        }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            print("didUpdateLocations DENIED")
            alertLocation()}
            
        else if CLLocationManager.authorizationStatus() == .denied{
            print("didUpdateLocations DENIED")
            alertLocation()}
        else {
            print("didUpdateLocations NO")
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()}
    }


    
    func alertLocation(){
        var alertController = UIAlertController(title: "Es necesaria la Ubicación Siempre", message: "cambia la configuarción de localización", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "ir a Configuraciones", style: .default, handler: { action in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)}))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locationManager.location)")
       
    }
    
    
    
}
