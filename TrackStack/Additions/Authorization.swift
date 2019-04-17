//
//  Authorization.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/17/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation
import LocalAuthentication
import UIKit

protocol AuthLocked {
    func authorized()
}

class Authorization {
    var delegate: AuthLocked?
    
    let context = LAContext()
    var error: NSError?
    
    func authorizationAttempt() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] (success, authenticationError) in
                
                DispatchQueue.main.async {
                    if success {
                        self.delegate?.authorized()
                    } else {
                        print("error")
                    }
                }
            }
        } else {
            print("No biometrics")
        }
    }
}
