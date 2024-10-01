import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var userLocation: CLLocation?
    @Published var locationError: Error?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.authorizationStatus = locationManager.authorizationStatus
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.startUpdatingLocation()
    }

    func requestLocationAsync() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            self.requestLocation()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.userLocation = location
                self.locationManager.stopUpdatingLocation()

                self.locationContinuation?.resume(returning: location)
                self.locationContinuation = nil
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = error
            self.locationContinuation?.resume(throwing: error)
            self.locationContinuation = nil
        }
    }
}
