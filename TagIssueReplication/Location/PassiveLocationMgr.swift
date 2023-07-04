//
//  PassiveLocationMgr.swift
//  TagIssueReplication
//
//  Created by Saroj Maharjan on 02/07/2023.
//

import MapboxMaps
import CoreLocation
import MapboxNavigation
import MapboxCoreNavigation

class PassiveLocationMgr: NSObject, ObservableObject {
    private let passiveLocationManager = PassiveLocationManager()
    private lazy var locationProvider = PassiveLocationProvider(locationManager: passiveLocationManager)
    
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
    }
    @Published var heading: CLHeading? {
        willSet { objectWillChange.send() }
    }
    var lattitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 0
    }
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 0
    }
    var mapLocationProvider: PassiveLocationProvider {
        return locationProvider
    }
    
    override init() {
        super.init()
//        passiveLocationManager.systemLocationManager.allowsBackgroundLocationUpdates = true
//        passiveLocationManager.systemLocationManager.showsBackgroundLocationIndicator = true
        locationProvider.delegate = self
        locationProvider.requestWhenInUseAuthorization()
        switch locationProvider.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            locationProvider.startUpdatingLocation()
            locationProvider.startUpdatingHeading()
        default: break
        }
        locationProvider.startUpdatingLocation()
    }
    
    var hasAccess: Bool {
        switch locationProvider.authorizationStatus {
        case .restricted, .denied:
            return false
        default:
            return true
        }
    }
}
extension PassiveLocationMgr: LocationProviderDelegate {
    func locationProvider(_ provider: LocationProvider, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        self.location = newLocation
    }
    
    func locationProvider(_ provider: LocationProvider, didUpdateHeading newHeading: CLHeading) {
        self.heading = newHeading
    }
    
    func locationProvider(_ provider: LocationProvider, didFailWithError error: Error) {
        
    }
    
    func locationProviderDidChangeAuthorization(_ provider: LocationProvider) {
        
    }
}
