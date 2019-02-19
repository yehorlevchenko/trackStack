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
    var testPriceCurrent = 3563.00
    
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionCurrencyImage: UIImageView!
    @IBOutlet weak var transactionPriceDiff: UIImageView!
    @IBOutlet weak var transactionPriceDiffLabel: UILabel!
    @IBOutlet weak var transactionDataLabel: UILabel!
    
    func setTransaction(data: Transaction) {
        let priceOrigin: String = String(format: "%.3f", data.priceOrigin)
        let priceDiff: String = String(format: "%.2f%", 100)
        
        transactionAmountLabel.text = "\(data.amount) \(data.currency!)"
        transactionDataLabel.text = "Buy: \(priceOrigin), Current: \(testPriceCurrent)"
        transactionCurrencyImage.image = UIImage(named: data.currency!)
        transactionPriceDiffLabel.text = "\(priceDiff)%"
        transactionPriceDiffLabel.textColor = data.priceOrigin > testPriceCurrent ? redColor : greenColor
        transactionPriceDiff.image = data.priceOrigin > testPriceCurrent ? UIImage(named: "priceDown") : UIImage(named: "priceUp")
    }    
}



