//
//  Update.swift
//  alwaysLocationTest
//
//  Created by Oz Zuñiga on 14/11/17.
//  Copyright © 2017 Oz Zuñiga. All rights reserved.
//
//  Crear variable "var version = update()" en AppDelegate.
//  mandar llamar variable " version.checkVersion(urlComprobacion:URL, urlDescargarNuevaVersion: URL)"
//  en la funcion del AppDelegate: didFinishLaunchingWithOptions.
//  con los parametros de la url donde se comprobará la version, y la url donde se encuentra la aplicación a descargar


import Foundation
import UIKit

class update{
    
    
    //COMPROBAR VERSIÓN:-----------------------------------------------------
    func checkVersion(urlComprobacion:URL, urlDescargarNuevaVersion: URL)-> String{
        var lastVersion: String = "Actualizada"
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String{print("NOMBRE: \(appName)")
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {print("VERSION: \(appVersion)")
                
                let request = NSMutableURLRequest(url:urlComprobacion)
                request.httpMethod = "POST"
                request.httpBody = ("nombre=\(appName)&version=\(appVersion)").data(using: String.Encoding.utf8)
                let task = URLSession.shared.dataTask(with: request as URLRequest) { (data,response,error) in
                    if error != nil{ print("error=\(String(describing: error))");return}
                    
                    if let jsonString = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: String]{
                        if jsonString ["status"] != "version_actual"{
                            lastVersion = "No Actualizada"
                            print("Hay una Nueva Versión")
                            
                        }else{ print("Versión Actual")}
                    }
                    
                }
                task.resume()
            }
        }
        return lastVersion
    }
    
}
