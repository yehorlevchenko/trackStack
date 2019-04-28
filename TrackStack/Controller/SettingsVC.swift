//
//  SettingsVC.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/18/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {

    @IBOutlet weak var biometricLockSwitch: UISwitch!
    
    let settings = UserDefaultsManager.changeableSettings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        biometricLockSwitch.isOn = UserDefaultsManager.biometricLock
    }
    
    @IBAction func biometricLockChanged(_ sender: Any) {
        UserDefaultsManager.biometricLock = biometricLockSwitch.isOn
    }
    
}
