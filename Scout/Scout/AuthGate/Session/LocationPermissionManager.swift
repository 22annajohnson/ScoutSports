//
//  LocationPermissionManager.swift
//  Scout
//
//  Created by Anna on 2/26/26.
//

import CoreLocation
import Observation
import SwiftUI

@MainActor
@Observable
final class LocationPermissionManager: NSObject, CLLocationManagerDelegate {
    var status: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        status = manager.authorizationStatus
    }

    func requestWhenInUse() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        status = manager.authorizationStatus
    }
}
