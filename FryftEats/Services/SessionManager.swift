//
//  SessionManager.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import CoreLocation

class SessionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = SessionManager()
    
    @Published var token: String?
    @Published var isLoggedIn: Bool = false
    @Published var user: User?
    @Published var currentLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
    private let defaults = UserDefaults.standard
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func login(token: String, user: User) {
        self.token = token
        self.user = user
        self.isLoggedIn = true
        defaults.set(token, forKey: "authToken")
    }
    
    func signUp(token: String, user: User) {
        login(token: token, user: user)
    }

    func logout() {
        self.token = nil
        self.user = nil
        self.isLoggedIn = false
        defaults.removeObject(forKey: "authToken")
    }

    func loadToken() -> String? {
        return defaults.string(forKey: "authToken")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            
            defaults.set(location.coordinate.latitude, forKey: "userLatitude")
            defaults.set(location.coordinate.longitude, forKey: "userLongitude")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .restricted, .denied:
            print("Location access was restricted or denied.")
        default:
            break
        }
    }
}
