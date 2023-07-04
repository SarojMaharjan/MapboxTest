//
//  ContentViewModel.swift
//  TagIssueReplication
//
//  Created by Saroj Maharjan on 02/07/2023.
//

import Foundation
import Combine

extension ContentView {
    @MainActor class ContentViewModel: NSObject, ObservableObject {
        let locationManager = PassiveLocationMgr()
        @Published var zoom: Float = 18
        @Published var nearbyDevices: [NearbyDevice] = []
        @Published var cancellables: Set<AnyCancellable> = []
        
        let dummyData: [NearbyDevice] = [
            NearbyDevice(id: UUID(), fullName: "Full Name1", lattitude: 27.66132, longitude: 85.30495692800613, profilePicture: "https://cdn.britannica.com/36/154236-050-8127D19C/Durbar-Square-Lalitpur-Nepal.jpg")
        ]
        
        func fetchNearbyDevices() {
            if locationManager.hasAccess {
                locationManager.$location.sink { [weak self] location in
//                    guard let location = location else { return }
//                    print("ContentViewModel: setting nearby devices. \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    self?.nearbyDevices = self?.dummyData ?? []
                }.store(in: &cancellables)
            }
        }
    }
}
