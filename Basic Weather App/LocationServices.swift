//
//  LocationServices.swift
//  Chase Code Challenge
//
//  Created by Alex on 5/25/23.
//

import Foundation
import CoreLocation

final class LocationServices: NSObject {
    static let shared = LocationServices()
    private var locationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    
    func requestLocationAuthorization() {
        locationManager.delegate = self
        
        /// we need to first find out if we have already requested permission or not
        /// if we havent ask user for permission
        let status = locationManager.authorizationStatus
        guard status == .notDetermined else { return }
        
        requestLocationAuthorizationCallback = { status in
            if status == .authorizedWhenInUse {
                self.locationManager.requestAlwaysAuthorization()
            }
        }
        locationManager.requestWhenInUseAuthorization()
    }

    var currentLocation: CLLocation? {
        /// grabs user current location, returnsn nil if we dont have permission
        switch locationManager.authorizationStatus {
        case .notDetermined, .denied, .restricted:
            return nil
        default:
            return locationManager.location
        }
    }
    
}

extension LocationServices: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocationAuthorizationCallback?(manager.authorizationStatus)
    }

}
