//
//  ContentView.swift
//  TagIssueReplication
//
//  Created by Saroj Maharjan on 02/07/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        MapboxViewRepresentable(zoom: $viewModel.zoom, nearbyDevices: $viewModel.nearbyDevices)
            .onAppear {
                viewModel.fetchNearbyDevices()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
