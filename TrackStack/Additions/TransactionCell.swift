//
//  TransactionCell.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 2/4/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import ChameleonFramework

class TransactionCell: UITableViewCell {
    
    var transaction: Transaction?
    let redColor = UIColor(hexString: "9F2121")
    let greenColor = UIColor(hexString: "219F4F")
    let greyColor = UIColor.flatGray()
    let cornerRadius: CGFloat = 6
    
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionBasePriceLabel: UILabel!
    @IBOutlet weak var transactionCurrencyImage: UIImageView!
    @IBOutlet weak var transactionPairLabel: UILabel!
    @IBOutlet weak var transactionPriceDiff: UIImageView!
    @IBOutlet weak var transactionPriceDiffLabel: UILabel!
    @IBOutlet weak var transactionPriceCurrentLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    func tuneView() {
        cellView.layer.cornerRadius = 9
    }
    
    func setTransaction(transaction: Transaction, currentPrice: Double, fiat: FiatCurrency, glyph: FiatGlyph) {
        let currencyGlyph: String = glyph.rawValue
        let priceOrigin: String = String(format: "\(currencyGlyph)%.2f", transaction.priceOrigin)
        let priceLast: String = String(format: "\(currencyGlyph)%.2f", transaction.amount * transaction.priceLast)
        let priceDiff: String = String(format: "%.2f", transaction.priceDiff)
        
        transactionAmountLabel.text = "\(transaction.amount)"
        transactionBasePriceLabel.text = priceOrigin
        transactionCurrencyImage.image = UIImage(named: transaction.currency!)
        transactionPairLabel.text = "\(transaction.currency!)-\(fiat.rawValue)"
        transactionPriceCurrentLabel.text = priceLast
        
        
        if (transaction.priceOrigin - currentPrice) > 0.1 {
            if transaction.priceOrigin > currentPrice {
                transactionPriceDiffLabel.text = "\(priceDiff)%"
                transactionPriceDiffLabel.textColor = redColor
                transactionPriceDiff.isHidden = false
                transactionPriceDiff.image = UIImage(named: "priceDown")
            } else {
                transactionPriceDiffLabel.text = "\(priceDiff)%"
                transactionPriceDiffLabel.textColor = greenColor
                transactionPriceDiff.isHidden = false
                transactionPriceDiff.image = UIImage(named: "priceUp")
            }
        } else {
            transactionPriceDiffLabel.text = "<0.1%"
            transactionPriceDiffLabel.textColor = greyColor
            transactionPriceDiff.isHidden = true
        }
    }
    
    func updateData(index: Int) {
        riseCurrencyLabel(index: index)
    }
    
    func riseCurrencyLabel(index: Int) {
        let delay = TimeInterval(Double(index) * 0.1)
        
        TransactionCell.animate(withDuration: 0.2, delay: delay, options: [.curveLinear], animations: {
            self.transactionCurrencyImage.center.y -= 5
        }) { (_) in
            self.downCurrencyLabel()
        }
    }
    
    func downCurrencyLabel() {
        TransactionCell.animate(withDuration: 0.1) {
            self.transactionCurrencyImage.center.y += 5
        }
    }
}



