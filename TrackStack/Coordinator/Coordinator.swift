//
//  Coordinators.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/9/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
