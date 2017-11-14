//
//  ViewController.swift
//  alwaysLocationTest
//
//  Created by Oz  on 10/11/17.
//  Copyright © 2017 Desarrollo Software. All rights reserved.
//
//ALERT!!!!!!
// agregar en archivo info.plis el valor:  Privacy - Location Always and When In Use Usage Description
// Habilitar en CApabilities de la app: BackGround Modes, Location updates


import UIKit
import CoreLocation // location framework

class ViewController: UIViewController, CLLocationManagerDelegate //delgate de location framework
{

    private let locationManager = CLLocationManager() //var para llamar location manager
    var latitude: Double = 0.0
    var longitude: Double = 0.0
   
    @IBOutlet weak var location: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self// delegate para location framework
     
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       self.Updates(version: "1.0")
        AutorizacionLocation(_fuctionCall: "viewDidAppear")// cuando apperece la vista llama a la funcion AutorizacionLocation para verificar que la auroizacion sea Always
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        AutorizacionLocation(_fuctionCall: "didChangeAuthorization") // cuando cambia el estatus de autorizacion de localización llama a la funcion AutorizacionLocation para verificar que la auroizacion sea Always
        
        
        
        
        
    }


    
    func alertLocation(){//alerta para cambiar la autorización de localización en las configuraciones de la app
        let alertController = UIAlertController(title: "Es necesaria la Ubicación Siempre", message: "cambia la configuarción de localización", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "ir a Configuraciones", style: .default, handler: { action in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)}))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //esto se realiza cuando las coordenadas cambian
        print("\(locationManager.location)")//imprime localización
        self.location.text = "\(locationManager.location!)"//ingresa localización en label"location"
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        print("Nuevas Coordenadas: ")
        print(self.latitude)
        print(self.longitude)
        
        sendLocation(latitude: self.latitude, longitude: self.longitude, state: "Launching")
        
        
    }
    
    func AutorizacionLocation(_fuctionCall: String){//funcion para verificar que el estatus de autorización sea always
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("\(_fuctionCall): ALWAYS")
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            //locationManager.allowsBackgroundLocationUpdates = true
            print("\(locationManager.location)")
            
        case .authorizedWhenInUse:
            print("\(_fuctionCall): WHEN IN USE")
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
    
    func Updates(version: String){
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("VERSION: \(version)")
            if appVersion != version{
                let alertController = UIAlertController(title: "ACTUALIZACIÓN", message: "Hay una nueva Version \(version)", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Actualizar", style: .default, handler: { action in
                   self.Updates(version: version)
                    let url = URL(string: "https://www.google.com")
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        //If you want handle the completion block than
                        UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                            
                            print("Open url : \(success)")
                        })
                    }
                    
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    func sendLocation(latitude:Double, longitude: Double, state:String){
        let request = NSMutableURLRequest(url: URL(string:"http://192.168.213.90:8888/locations.php")!)
        request.httpMethod = "POST"
        let postString = "latitude=\(latitude)&longitude=\(longitude)&app_state=\(state)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data,response,error) in
            if error != nil{print("error=\(error)")
                return
            }
            print ("mandado latitude =\(latitude)&longitude =\(longitude))")
            print ("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print ("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    
}
