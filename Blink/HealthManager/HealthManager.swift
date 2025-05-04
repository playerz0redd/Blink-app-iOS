//
//  HealthManager.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.05.25.
//

import Foundation
import HealthKit

protocol IHealth {
    func fetchStepAmount() -> Int
}

class HealthManager {
    
    private let healthStore = HKHealthStore()
    
    private func getPermission() -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }
        
        let typesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!]
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
            } catch {
                return false
            }
            return true
        }
        return true
    }
    
    func getStepAmount() async throws -> Double {
        guard getPermission() else { return 0 }
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let steps = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                continuation.resume(returning: steps)
            }
            healthStore.execute(query)
        }
    }
    
}
