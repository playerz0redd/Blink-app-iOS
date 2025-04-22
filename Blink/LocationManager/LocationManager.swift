//
//  LocationManager.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 20.04.25.
//

import Foundation
import CoreLocation
import SwiftUI


class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager : CLLocationManager?
    @Published var location : CLLocationCoordinate2D?
    
    @MainActor func checkLocationServicesIsEnabled() throws(ApiError) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 50
            locationManager?.startUpdatingLocation()
        } else {
            print("---")
            throw .appError(.locationIsNotAllowed)
        }
    }
    
    private func checkLocationAllowed() {
        guard let locationManager = locationManager else {
            print("location error")
            return
        }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            print("Location error")
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("Location error")
            //throw .appError(.locationIsNotAllowed)
        case .denied:
            print("Location error")
            //throw .appError(.locationIsNotAllowed)
        case .authorizedAlways:
            print("ok")
            locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            print("Location error")
            //throw .appError(.locationIsNotAllowed)
        @unknown default:
            print("Location error")
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAllowed()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last?.coordinate
    }
}
