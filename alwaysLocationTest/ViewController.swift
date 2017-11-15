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
//


import UIKit
import CoreLocation // location framework

class ViewController: UIViewController, CLLocationManagerDelegate //delgate de location framework
{
    var ubicacion = Location()
    var version = update()
    var persmiso = false
   /* private let locationManager = CLLocationManager() //var para llamar location manager
    var latitude: Double = 0.0//var para latitud
    var longitude: Double = 0.0//var para longitud*/
   
    @IBOutlet weak var location: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self// delegate para location framework
     
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //version.checkVersion(urlComprobacion:URL(string:"http://192.168.213.90:8888/versiones.php")!, urlDescargarNuevaVersion:URL(string:"http://google.com")!)
       
     //   }else{DispatchQueue.main.async {self.performSegue(withIdentifier: "update", sender: self)}}
      
      ubicacion.AutorizacionLocation()
    }
        /*
    
//FUNCION CUANDO PERMISOS DE LOCALIZACION CAMBIA-----------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        AutorizacionLocation(_fuctionCall: "didChangeAuthorization") // cuando cambia el estatus de autorizacion de localización llama a la funcion AutorizacionLocation para verificar que la auroizacion sea Always
    }
    
//FUNCION CUANDO LOCALIZACION CAMBIA-----------------------------------------------------
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
        
        sendLocation(latitude: self.latitude, longitude: self.longitude, state: "Launching")//funcion para mandar ubicación
        
        
    }
    
//VERIFICAR PERMISOS DE LOCALIZACIÓN:-----------------------------------------------------
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
    }*/
    

//ALERTA DE CONFIGURACIONES-----------------------------------------------------
    func alertLocation(){//alerta para cambiar la autorización de localización en las configuraciones de la app
        let alertController = UIAlertController(title: "Es necesaria la Ubicación Siempre", message: "cambia la configuarción de localización", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "ir a Configuraciones", style: .default, handler: { action in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)}))
        self.present(alertController, animated: true, completion: nil)
    }
    
  
    

  

  /*
    
//COMPROBAR VERSIÓN:-----------------------------------------------------
    func Updates(){
        
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String{print("NOMBRE: \(appName)")
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {print("VERSION: \(appVersion)")
            
            let request = NSMutableURLRequest(url: URL(string:"http://192.168.213.90:8888/versiones.php")!)
            request.httpMethod = "POST"
            request.httpBody = ("nombre=\(appName)&version=\(appVersion)").data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data,response,error) in
                if error != nil{ print("error=\(String(describing: error))");return}
                
                if let jsonString = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: String]{
                    if jsonString ["status"] == "version_antigua"{
                        DispatchQueue.main.async {self.performSegue(withIdentifier: "update", sender: self)}
                    }
                }
               
            }
            task.resume()
        }
        }
    }
    

//MANDAR UBICACIÓN:-----------------------------------------------------
    func sendLocation(latitude:Double, longitude: Double, state:String){
        let request = NSMutableURLRequest(url: URL(string:"http://192.168.213.90:8888/locations.php")!)
        request.httpMethod = "POST"
        let postString = "latitude=\(latitude)&longitude=\(longitude)&app_state=\(state)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data,response,error) in
            if error != nil{print("error=\(error)")
                return
            }
        }
        task.resume()
    }*/
    
}
