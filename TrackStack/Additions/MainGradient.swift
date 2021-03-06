//
//  MainGradient.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/8/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit

class MainGradient {
    var gl: CAGradientLayer!
    let colorTop = UIColor(red: 48.0 / 255.0, green: 35.0 / 255.0, blue: 174.0 / 255.0, alpha: 1.0).cgColor
    let colorBottom = UIColor(red: 200.0 / 255.0, green: 109.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0).cgColor
    
    init() {
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
        self.gl.startPoint = CGPoint(x: 0, y: 0)
        self.gl.endPoint = CGPoint(x: 1, y: 1)
    }
    
    func image(frame: CGRect) -> UIImage? {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [self.colorTop, self.colorBottom]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        UIGraphicsBeginImageContext(frame.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
