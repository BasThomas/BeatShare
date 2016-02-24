//
//  HealthManager.swift
//  Water
//
//  Created by Bas Broek on 06/01/16.
//  Copyright © 2016 Bas Broek. All rights reserved.
//

import UIKit
import HealthKit

class HealthManager {
  
  private let store = HKHealthStore()
  
  func authorize(completion: (success: Bool, error: NSError?) -> Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(success: false, error: nil)
      return
    }
    
    let write: Set<HKSampleType> = []
    let read: Set<HKSampleType> = [HKQuantityType.heartRate]
    
    store.requestAuthorizationToShareTypes(write, readTypes: read) { success, error in
      completion(success: success, error: error)
    }
  }
  
  func observeHeartRate(completion: (result: Double?, error: NSError?) -> Void) {
    let sampleType = HKQuantityType.heartRate
    
    let observerQuery = HKObserverQuery(sampleType: sampleType, predicate: nil) { query, completionHandler, error in
      if let error = error {
        print("An error occurred: \(error.localizedDescription)")
        abort()
      }
      print("The completionHandler of the observerQuery was just called. Now request the info for this query.")
      
      let sorter = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
      let query = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 1, sortDescriptors: [sorter]) { _, results, error in
        let doubleResult = (results as? [HKQuantitySample])?.map { $0.quantity.doubleValueForUnit(HKUnit(fromString: "count/min")) }.last
        completion(result: doubleResult, error: error)
      }
      
      self.store.executeQuery(query)
    }
    
    store.executeQuery(observerQuery)
  }
}