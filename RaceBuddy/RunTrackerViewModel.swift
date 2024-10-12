//
//  RunTrackerViewModel.swift
//  RaceBuddy
//
//  Created by Arnav Srinivasan on 10/12/24.
//

import Foundation
import CoreLocation
import MapKit
import HealthKit

class RunTrackerViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var distance: Double = 0.0
    @Published var formattedTime: String = "00:00:00"
    @Published var isRunning = false
    
    private var locationManager: CLLocationManager
    private var locations: [CLLocation] = []
    private var startTime: Date?
    private var timer: Timer?
    
    var healthKitManager = HealthKitManager()
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    func checkLocationAuthorization() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startRun() {
        startTime = Date()
        distance = 0.0
        locations.removeAll()
        isRunning = true
        locationManager.startUpdatingLocation()
        
        // Start Timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimer()
        }
    }
    
    func stopRun() {
        locationManager.stopUpdatingLocation()
        isRunning = false
        timer?.invalidate()
        // Save run data to HealthKit
        healthKitManager.saveRun(distance: distance, startTime: startTime!, endTime: Date())
    }
    
    func updateTimer() {
        guard let startTime = startTime else { return }
        let elapsedTime = Date().timeIntervalSince(startTime)
        formattedTime = formatTime(elapsedTime)
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            locations.append(contentsOf: newLocations)
            return
        }
        
        for location in newLocations {
            let delta = location.distance(from: lastLocation)
            distance += delta
            locations.append(location)
        }
        
        if let last = newLocations.last {
            region = MKCoordinateRegion(center: last.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
    }
}
