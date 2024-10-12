//
//  HealthKitManager.swift
//  RaceBuddy
//
//  Created by Arnav Srinivasan on 10/12/24.
//

import Foundation
import HealthKit

class HealthKitManager{
    let store = HKHealthStore()
    
    init() {
        requestAuth()
    }
    
    func requestAuth() {
        let share: Set = [
            HKObjectType.workoutType(),
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        let read: Set = [
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        store.requestAuthorization(toShare: share, read: read) { success, error in
            if success {
                print("Authorized")
            } else {
                print("Not Authorized")
            }
        }
    }
    
    func saveRun(distance: Double, startTime: Date, endTime: Date) {
        let workout = HKWorkout(
            activityType: .running, start: startTime, end: endTime,
            duration: endTime.timeIntervalSince(startTime),
            totalEnergyBurned: nil,
            totalDistance: HKQuantity(unit: HKUnit.mile(), doubleValue: distance),
            device: HKDevice.local(),
            metadata: nil
        )
        store.save(workout) { success, error in
            if success {
                print("Saved")
            } else {
                print("Not Saved")
            }
        }
    }
}
