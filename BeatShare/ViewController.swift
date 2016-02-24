//
//  ViewController.swift
//  BeatShare
//
//  Created by Bas Broek on 2/21/16.
//  Copyright © 2016 Bas Broek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let manager = HealthManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    manager.authorize { success, error in
      if success {
        self.manager.requestHeartRate()
      } else {
        print("Denied: \(error?.localizedDescription)")
      }
    }
  }
}