//
//  RaceBuddyApp.swift
//  RaceBuddy
//
//  Created by Hisham Bhatti on 10/12/24.
//

import SwiftUI
#if canImport(UIKit)
    import UIKit
#endif
import CoreLocation
import HealthKit
import MapKit

@main
struct RaceBuddyApp: App {
    @StateObject private var runTrackerViewModel = RunTrackerViewModel()
    var body: some Scene {
        WindowGroup {
            RunTrackerView().environmentObject(runTrackerViewModel)
        }
    }
}
