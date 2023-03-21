//
//  LocationManager.swift
//  WeatherApp
//
//  Created by HungNguyen on 2023/03/16.
//

import Foundation
import CoreLocation
import Combine

protocol LocationManagerProtocol {
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }
    func requestLocationOnce()
}

final class LocationManager: NSObject {
    
    // MARK: - Private properties
    
    private lazy var locationSubject = PassthroughSubject<CLLocation, Never>()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
}

// MARK: - LocationManagerProtocol

extension LocationManager: LocationManagerProtocol {

    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    
    func requestLocationOnce() {
        if let savedLocation = getSavedLocation() {
            locationSubject.send(savedLocation)
        }
        
        let status = locationManager.authorizationStatus
        let isGranted = status == .authorizedAlways || status == .authorizedWhenInUse
        if isGranted {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        locationSubject.send(location)
        saveLocation(location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        let isGranted = status  == .authorizedAlways || status == .authorizedWhenInUse
        if isGranted {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}

// MARK: - Caching location

/// Requesting location is long running task so we cache location using UserDefaults and we will return it first in next requesting time
private extension LocationManager {
    static let savedLocationLat = "savedLocationLat"
    static let savedLocationLon = "savedLocationLon"
    
    var userDefaults: UserDefaults { UserDefaults.standard }

    func saveLocation(_ location: CLLocation) {
        userDefaults.set(location.coordinate.latitude, forKey: LocationManager.savedLocationLat)
        userDefaults.set(location.coordinate.longitude, forKey: LocationManager.savedLocationLon)
    }
    
    func getSavedLocation() -> CLLocation? {
        guard let latitude = userDefaults.object(forKey: LocationManager.savedLocationLat) as? Double,
              let longitude = userDefaults.object(forKey: LocationManager.savedLocationLon) as? Double
        else {
            return nil
        }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
