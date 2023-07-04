//
//  MapboxViewRepresentable.swift
//  TagIssueReplication
//
//  Created by Saroj Maharjan on 02/07/2023.
//

import SwiftUI
import UIKit
import MapboxMaps
import CoreLocation
import Kingfisher

struct MapboxViewRepresentable: UIViewControllerRepresentable {
    
    @Binding var zoom: Float
    @Binding var nearbyDevices: [NearbyDevice]
    
    func makeUIViewController(context: Context) -> MapboxViewController {
        let controller = MapboxViewController()
        controller.devices = self.nearbyDevices
        controller.zoom = self.zoom
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MapboxViewController, context: Context) {
        uiViewController.devices = self.nearbyDevices
        uiViewController.zoom = self.zoom
    }
}

class MapboxViewController: UIViewController {
    @ObservedObject var locationProvider = PassiveLocationMgr()
    
    internal var mapView: MapView!
    
    var zoom: Float = 18
    var devices: [NearbyDevice] = [] {
        didSet {
            plotNearbyDevices()
        }
    }
    var currentMarkers: [PointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cameraOption = CameraOptions(
            center: CLLocationCoordinate2D( latitude: locationProvider.lattitude.magnitude, longitude: locationProvider.longitude.magnitude),
            padding: UIEdgeInsets( top: 40.0, left: 5.0, bottom: 80.0, right: 5.0), zoom: CGFloat(zoom), bearing: CLLocationDirection(locationProvider.heading?.magneticHeading ?? 0)
        )
        let resourceOptions = ResourceOptions(accessToken: "sk.eyJ1Ijoic2FuamF5YWFkaGlrYXJpIiwiYSI6ImNsNDhvbHFyNTBlb2YzY3IyaXIyNGV1cnQifQ.Cpu4AJDPFc3jx1N1A_CsXw")
        let mapInitOptions = MapInitOptions(resourceOptions: resourceOptions, cameraOptions: cameraOption, styleURI: StyleURI.light)
        mapView = MapView(frame: view.bounds, mapInitOptions: mapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.location.overrideLocationProvider(with: locationProvider.mapLocationProvider)
        mapView.location.options.puckType = .puck2D()
        recenterMap()
        self.view.addSubview(mapView)
    }
    
    func recenterMap() {
        let followPuckViewportState = mapView.viewport.makeFollowPuckViewportState(options: FollowPuckViewportStateOptions(padding: UIEdgeInsets(top: 450, left: 0, bottom: 250, right: 0), zoom: CGFloat(zoom), bearing: .course, pitch: 45))
        self.mapView.viewport.transition(to: followPuckViewportState) { _ in }
    }
    
    private func plotNearbyDevices() {
        guard mapView != nil else { return }
        let annotationMgr = mapView.annotations.makePointAnnotationManager(id: "annotationLayer")
        var markers: [PointAnnotation] = []
        for device in devices {
            if var marker = currentMarkers.first(where: { $0.id == device.id.uuidString }) {
                let deviceCoordinate = CLLocationCoordinate2D(latitude: device.lattitude, longitude: device.longitude)
                
//                annotationMgr.annotations.first(where: { $0.id == device.id.uuidString })?.point.coordinates = deviceCoordinate
                
                marker.point.coordinates = deviceCoordinate
                markers.append(marker)
            } else {
                let markerImage = UIImage(named: "ic_circle")
                let deviceCoordinate = CLLocationCoordinate2D(latitude: device.lattitude, longitude: device.longitude)
                var pointAnnotation = PointAnnotation(id: device.id.uuidString, coordinate: deviceCoordinate)
                pointAnnotation.image = .init(image: markerImage!, name: "\(device.id.uuidString)")
                pointAnnotation.iconAnchor = .bottom
                markers.append(pointAnnotation)
            }
        }
        currentMarkers = markers
        annotationMgr.annotations = currentMarkers
    }
}
