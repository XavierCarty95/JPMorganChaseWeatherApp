//
//  MapView.swift
//  JPMorganWeatherApp
//
//  Created by Xavier Carty on 9/27/24.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    var lat: Double
    var lon: Double

    @State private var region: MKCoordinateRegion
    @State private var userTrackingMode: MapUserTrackingMode = .follow

    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
           Map(coordinateRegion: $region)
               .onAppear {
                   updateRegion()
               }
               .onChange(of: lat) { _ in
                   updateRegion()
               }
               .onChange(of: lon) { _ in
                   updateRegion()
               }
       }

       private func updateRegion() {
           region = MKCoordinateRegion(
               center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
               span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
           )
       }
}
