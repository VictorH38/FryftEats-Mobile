//
//  SessionManager.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import CoreLocation

class SessionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Singleton instance to access session data globally.
    static let shared = SessionManager()
    
    // Published properties to trigger UI updates on changes.
    @Published var token: String?
    @Published var isLoggedIn: Bool = false
    @Published var user: User?
    @Published var currentLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
    private let defaults = UserDefaults.standard
    
    override init() {
        super.init()
        // Set up location manager and request location updates.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Logs the user in and stores the auth token in UserDefaults.
    func login(token: String, user: User) {
        self.token = token
        self.user = user
        self.isLoggedIn = true
        defaults.set(token, forKey: "authToken")
    }
    
    // Alias for login to handle signup actions.
    func signUp(token: String, user: User) {
        login(token: token, user: user)
    }

    // Logs the user out and clears the session and token.
    func logout() {
        self.token = nil
        self.user = nil
        self.isLoggedIn = false
        defaults.removeObject(forKey: "authToken")
    }

    // Retrieves the auth token from UserDefaults.
    func loadToken() -> String? {
        return defaults.string(forKey: "authToken")
    }
    
    // CLLocationManager delegate method for updating locations.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            // Store latest location in UserDefaults.
            defaults.set(location.coordinate.latitude, forKey: "userLatitude")
            defaults.set(location.coordinate.longitude, forKey: "userLongitude")
        }
    }
    
    // CLLocationManager delegate method for handling location errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // Handles location authorization changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // Request authorization when status is not determined.
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // Start location updates when authorized.
            manager.startUpdatingLocation()
        case .restricted, .denied:
            // Handle case where location services are denied or restricted.
            print("Location access was restricted or denied.")
        default:
            break
        }
    }
}
