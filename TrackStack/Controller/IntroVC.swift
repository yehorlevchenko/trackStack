//
//  IntroVC.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/8/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import Lottie

class IntroVC: UIViewController, AuthLocked {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var safetyButton: UIView!
    @IBOutlet weak var safetyLabel: UILabel!
    let settings = UserDefaults.standard
    let authorization = Authorization()
    var launchedOnce: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorization.delegate = self
        launchedOnce = settings.bool(forKey: "launchedOnce")
        
        self.navigationController?.navigationBar.isHidden = true
        
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.safetyTapped))
        self.safetyButton.addGestureRecognizer(gesture)
        
        if launchedOnce {
            safetyLabel.text = "Authorize"
            skipButton.isHidden = true
        } else {
            safetyLabel.text = "Set up your safety"
            settings.set(true, forKey: "launchedOnce")
        }
    }
    
    func authorized() {
        performSegue(withIdentifier: "mainScreen", sender: self)
    }
    
    @IBAction func skipToMainTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "mainScreen", sender: self)
    }
    
    @objc func safetyTapped(sender: UITapGestureRecognizer) {
        if launchedOnce {
            authorization.authorizationAttempt()
        } else {
            performSegue(withIdentifier: "safetyScreen", sender: self)
        }
        
    }
}
