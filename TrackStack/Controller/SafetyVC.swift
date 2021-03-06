//
//  SafetyVC.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/8/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import LocalAuthentication

class SafetyVC: UIViewController, AuthLocked {
    
    @IBOutlet weak var disclaimerLabel: UILabel!
    let authorization = Authorization()
    let settings = UserDefaults.standard
    let safetyText: String = """
    TrackStack will store the amount of currency you have bought, it’s original price and price dynamics retrospective.

    Your data would not be moved, stored anywhere outside this device.

    TrackStack has nothing to do with your currency itself and has no access to it.

    TrackStack would not request, receive any external information, except current prices on your request. The only source of data for this app is Bitcoinaverage.com.

    It is recommended to use Touch ID, Face ID to protect your data locally. Otherwise, your local data might be vulnerable.
    """
    
    override func viewDidLoad() {
        disclaimerLabel.text = safetyText
        authorization.delegate = self
    }
    
    func authorized() {
        UserDefaultsManager.biometricLock = true
        performSegue(withIdentifier: "mainScreen", sender: self)
    }
    
    @IBAction func authTapped(_ sender: Any) {
        authorization.authorizationAttempt()
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        UserDefaultsManager.biometricLock = false
        performSegue(withIdentifier: "mainScreen", sender: self)
    }
}
