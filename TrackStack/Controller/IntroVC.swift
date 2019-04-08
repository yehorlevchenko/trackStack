//
//  IntroVC.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/8/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation
import Lottie

class IntroVC: UIViewController {
    
    @IBOutlet weak var SafetyButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup gradient background
        let colors = MainGradient()
        let backgroundLayer = colors.gl
        backgroundLayer!.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
        
        // Setup animation
        let animationView = LOTAnimationView(name: "coin_loader")
        let animationSize: Int = Int(self.view.frame.width / 2)
        animationView.frame = CGRect(x: 0, y: 0, width: animationSize, height: animationSize)
        animationView.center = self.view.center
        animationView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 100)
        animationView.contentMode = .scaleAspectFit
        animationView.loopAnimation = true
        
        view.addSubview(animationView)
        animationView.play()
        
        // Setup Safety button
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.proceedToSafety))
        self.SafetyButton.addGestureRecognizer(gesture)
    }
    
    @objc func proceedToSafety(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "safetyScreen", sender: self)
    }
}