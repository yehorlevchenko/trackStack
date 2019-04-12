//
//  MainCoordinator.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/9/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = IntroVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func proceedToSafety() {
        let vc = SafetyVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func proceedToMain() {
        let vc = MainVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
