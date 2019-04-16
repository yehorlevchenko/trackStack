//
//  TransactionCell.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 2/4/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class TransactionCell: SwipeTableViewCell {
    
    var transaction: Transaction?
    let redColor = UIColor(hexString: "9F2121")
    let greenColor = UIColor(hexString: "219F4F")
    
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionCurrencyImage: UIImageView!
    @IBOutlet weak var transactionPriceDiff: UIImageView!
    @IBOutlet weak var transactionPriceDiffLabel: UILabel!
    @IBOutlet weak var transactionDataLabel: UILabel!
    
    func setTransaction(transaction: Transaction, currentPrice: Double) {
        let priceOrigin: String = String(format: "%.3f", transaction.priceOrigin)
        let priceDiff: String = String(format: "%.2f%", transaction.priceDiff)
        
        transactionAmountLabel.text = "\(transaction.amount) \(transaction.currency!)"
        transactionDataLabel.text = "Buy: \(priceOrigin), Current: \(currentPrice)"
        transactionCurrencyImage.image = UIImage(named: transaction.currency!)
        transactionPriceDiffLabel.text = transaction.priceOrigin > currentPrice ? "-"+priceDiff+"%" : priceDiff+"%"
        transactionPriceDiffLabel.textColor = transaction.priceOrigin > currentPrice ? redColor : greenColor
        transactionPriceDiff.image = transaction.priceOrigin > currentPrice ? UIImage(named: "priceDown") : UIImage(named: "priceUp")
    }
    
    func updateData() {
<<<<<<< HEAD
//        print("Update")
        currencyImageJump()
        diffLabelSwitch()
    }
    
    func currencyImageJump() {
        let jumpDelay = TimeInterval(Double(self.index) * 0.3)
        let jump = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut) {
            self.transactionCurrencyImage.center.y += 8
        }
        jump.startAnimation(afterDelay: jumpDelay)
    }
    
    func diffLabelSwitch() {
        let turn = UIViewPropertyAnimator(duration: 0.6, curve: .easeInOut) {
            self.transactionPriceDiff.transform = self.transactionPriceDiff.transform.rotated(by: .pi/1)
        }
        
        turn.startAnimation()
=======
        print("Cell is updated")
>>>>>>> parent of 7675519... Coordinators coming
    }
}



