//
//  Location.swift
//  alwaysLocationTest
//
//  Created by Oz Zuñiga on 14/11/17.
//  Copyright © 2017 Oz Zuñiga. All rights reserved.
//  Editar la url a la cual mandaras los datos de ubicacion: latitude, longitude
//  Crear variable " var ubicacion = Location() " en las clases AppDelegate y en la clase principal del viewController principal
//  Llamar funcion "ubicacion.doBackgroundTask()" dentro de AppDelegate, applicationDidEnterBackground; par obtener ubicacion en backgorund
//  Llamar funcion "ubicacion.AutorizacionLocation()" en viewDidAppear del viewController inicial
//

import Foundation
import CoreLocation
import UIKit

class Location: UIViewController, CLLocationManagerDelegate{
    
    var url = URL (string:"http://192.168.213.90:8888/location.php")!
    var locationManager = CLLocationManager()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    var bgtimer = Timer()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var current_time = NSDate().timeIntervalSince1970
    let alertController = UIAlertController(title: "Para ofrecerte el mejor uso de la aplicación Es necesaria la Ubicación Siempre", message: "cambia la configuarción de Ubicación", preferredStyle: UIAlertControllerStyle.alert)
   
    

    
  
//VERIFICAR PERMISOS DE LOCALIZACIÓN:-----------------------------------------------------
    func AutorizacionLocation(){//funcion para verificar que el estatus de autorización sea always
       
        let vc = Location.topViewController()
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("ALWAYS")
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            //locationManager.allowsBackgroundLocationUpdates = true
            print("\(String(describing: locationManager.location))")
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            alertLocation(vc: vc!)
        case .denied:
            print("DENIED")
            alertLocation(vc: vc!)
        case .notDetermined:
              print("NOT DETERMINED")
              locationManager.requestWhenInUseAuthorization()
              locationManager.requestAlwaysAuthorization()
        default:
            print("NO")
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
      
       /* if CLLocationManager.authorizationStatus() == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
        
       else if CLLocationManager.authorizationStatus() == tipo{
            status = true
            locationManager.delegate = self
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }*/
        
    }
    
//ALERTA DE CONFIGURACIONES-----------------------------------------------------
    func alertLocation(vc: UIViewController){//alerta para cambiar la autorización de localización en las configuraciones de la app
        
        alertController.addAction(UIAlertAction(title: "ir a Configuraciones", style: .default, handler: { action in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
            if CLLocationManager.authorizationStatus() != .authorizedAlways{self.AutorizacionLocation()}
            else{self.alertController.dismiss(animated: true, completion: nil)}
        }))
          vc.present(alertController, animated: true, completion: nil)
    }
    
   
    
//FUNCION CUANDO LOCALIZACION CAMBIA-----------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(String(describing: locationManager.location))")
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        print("Nuevas Coordenadas: ")
        print(self.latitude)
        print(self.longitude)
        sendLocation(latitude: self.latitude, longitude: self.longitude)
        
    }
    
    
    
//FUNCION CUANDO PERMISOS DE LOCALIZACION CAMBIA-----------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() != .authorizedAlways{
           self.AutorizacionLocation()
        }
        else{alertController.dismiss(animated: true, completion: nil) }
         // cuando cambia el estatus de autorizacion de localización llama a la funcion AutorizacionLocation para verificar que la auroizacion sea Always
    }
    
    
//MANDAR UBICACIÓN:-----------------------------------------------------
    func sendLocation(latitude:Double, longitude: Double){
        let request = NSMutableURLRequest(url:url)
        request.httpMethod = "POST"
        let postString = "latitude=\(latitude)&longitude=\(longitude)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data,response,error) in
            if error != nil{print("error=\(String(describing: error))")
                print("ERROR en Manadar Ubicación")
                return
            }
        }
        task.resume()
    }
    
    
    
//BACKGROUND:----------------------------------------------------------------
    func doBackgroundTask() {
        DispatchQueue.main.async { //en hilo principal
            self.beginBackgroundUpdateTask()
            self.StartupdateLocation()
            self.bgtimer = Timer.scheduledTimer(timeInterval: 1*60, target: self, selector: #selector(Location.bgtimer(_:)), userInfo: nil, repeats: true)//repetir cada segundo
            RunLoop.current.add(self.bgtimer, forMode: RunLoopMode.defaultRunLoopMode)
            RunLoop.current.run()
            self.endBackgroundUpdateTask()
            
        }
    }
//EMPIEZA TASK:-------------------------------------------------------------
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            // self.endBackgroundUpdateTask()
        })
    }
//FINALIZA TASK:---------------------------------------------------------
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    func StartupdateLocation() {
        //configuracion de localizacion
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error en obtener coordenadas")
    }
    
    @objc func bgtimer(_ timer:Timer!){self.updateLocation()}
    
    func updateLocation() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
    }
}

extension Location {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}


