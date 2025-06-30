//
//  MyMapView.swift
//  SwiftUITester
//
//  Created by xattacker.tao on 2024/12/2.
//  Copyright © 2024 Xattacker. All rights reserved.
//

import SwiftUI
import MapKit

fileprivate struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MyMapView: View, CustomNavigationDisplayer {
    var navigationTitle: String
    {
        return "MapView"
    }

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.048105551746932, longitude: 121.51726423859233), // 台北車站
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03) // zoom lv
    )
    
    private let places = [
           Place(name: "華山1914文化創意產業園區", coordinate: CLLocationCoordinate2D(latitude: 25.04460636764697, longitude: 121.52958094190951)),
           Place(name: "國立中正紀念堂", coordinate: CLLocationCoordinate2D(latitude: 25.036181798791787, longitude: 121.5200131088864)),
           Place(name: "San Diego", coordinate: CLLocationCoordinate2D(latitude: 32.7157, longitude: -117.1611))
       ]
       
    
    var body: some View {
        CustomViewContainer(
            content: {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: places) {
                    place in
                    MapMarker(coordinate: place.coordinate, tint: .red)
                }
                .onChange(of: region) {
                    newRegion in
                    let zoomLevel = calculateZoomLevel(for: newRegion)
                    print("zoomLevel: \(zoomLevel)")
                }
            },
            navigationDisplayer: self)
    }
    
    private func calculateZoomLevel(for region: MKCoordinateRegion) -> Double {
        let longitudeDelta = region.span.longitudeDelta
        // Zoom Level: 公式可以根據需求進行調整
        return log2(360 / longitudeDelta)
    }
}


extension MKCoordinateRegion: @retroactive Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude &&
        lhs.center.longitude == rhs.center.longitude &&
        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
        lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
