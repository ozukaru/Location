//
//  ViewController.swift
//  alwaysLocationTest
//
//  Created by Oz  on 10/11/17.
//  Copyright © 2017 Desarrollo Software. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
   
    @IBOutlet weak var location: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
     
       
    }
    
    override func viewDidAppear(_ animated: Bool) {AutorizacionLocation(_fuctionCall: "viewDidAppear")}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        AutorizacionLocation(_fuctionCall: "didChangeAuthorization")
    }


    
    func alertLocation(){
        let alertController = UIAlertController(title: "Es necesaria la Ubicación Siempre", message: "cambia la configuarción de localización", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "ir a Configuraciones", style: .default, handler: { action in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)}))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locationManager.location)")
        self.location.text = "\(locationManager.location!)"
    }
    
    func AutorizacionLocation(_fuctionCall: String){
        
      /*  if CLLocationManager.authorizationStatus() == .authorizedAlways {
            print("\(_fuctionCall): ALWAYS")
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("\(locationManager.location)")
            
        }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            print("\(_fuctionCall): DENIED")
            alertLocation()}
            
        else if CLLocationManager.authorizationStatus() == .denied{
            print("\(_fuctionCall): DENIED")
            alertLocation()}
        else {
            print("\(_fuctionCall): NO")
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()}*/
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("\(_fuctionCall): ALWAYS")
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            print("\(locationManager.location)")
        case .authorizedWhenInUse:
            print("\(_fuctionCall): DENIED")
            alertLocation()
        case .denied:
            print("\(_fuctionCall): DENIED")
            alertLocation()
        default:
            print("\(_fuctionCall): NO")
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
           }
        
    }
    
}
