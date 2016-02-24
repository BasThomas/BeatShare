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
  
  func requestHeartRate() {
    let sampleType = HKQuantityType.heartRate
    
    let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { query, completionHandler, error in
      if let error = error {
        print("An error occurred: \(error.localizedDescription)")
        abort()
      }
      
      print(query)
      print("now, request the info for this query.")
    }
    
    store.executeQuery(query)
  }
}