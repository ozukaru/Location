//
//  AppDelegate.swift
//  alwaysLocationTest
//
//  Created by Oz Zuñiga on 10/11/17.
//  Copyright © 2017 Oz Zuñiga . All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var locationManager = CLLocationManager()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    var bgtimer = Timer()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var current_time = NSDate().timeIntervalSince1970
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        locationManager.delegate = self
    }

   

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Entering Backround")
        self.doBackgroundTask()
    }
    
    
    func doBackgroundTask() {
        DispatchQueue.main.async {
            self.beginBackgroundUpdateTask()
            self.StartupdateLocation()
            self.bgtimer = Timer.scheduledTimer(timeInterval: 1*60, target: self, selector: #selector(AppDelegate.bgtimer(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(self.bgtimer, forMode: RunLoopMode.defaultRunLoopMode)
            RunLoop.current.run()
            self.endBackgroundUpdateTask()
            
        }
    }
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    func StartupdateLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while requesting new coordinates")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        print("Nuevas Coordenadas: ")
        print(self.latitude)
        print(self.longitude)
    }
    
    @objc func bgtimer(_ timer:Timer!){self.updateLocation()}
    
    func updateLocation() {
        self.locationManager.startUpdatingLocation()
        self.locationManager.stopUpdatingLocation()
    }

}

