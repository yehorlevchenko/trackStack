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
        let priceCurrent: String = String(format: "%.3f", testPriceCurrent)
        let priceDiff: String = String(format: "%.2f%", data.priceDiff)
        
        transactionAmountLabel.text = "\(data.amount) \(data.currency!)"
        transactionDataLabel.text = "Buy: \(priceOrigin), Current: \(testPriceCurrent)"
        transactionCurrencyImage.image = UIImage(named: data.currency!)
        transactionPriceDiffLabel.text = "\(priceDiff)%"
        transactionPriceDiffLabel.textColor = data.priceOrigin > testPriceCurrent ? redColor : greenColor
        transactionPriceDiff.image = data.priceOrigin > testPriceCurrent ? UIImage(named: "priceDown") : UIImage(named: "priceUp")
    }
    
//    var transactionView: UITextView = {
//        var textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
//
//    var currencyImageView: UIImageView = {
//        var imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        self.addSubview(transactionView)
//        self.addSubview(currencyImageView)
//
//        currencyImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        currencyImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        currencyImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        currencyImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//
//        transactionView.leftAnchor.constraint(equalTo: self.currencyImageView.rightAnchor).isActive = true
//        transactionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        transactionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        transactionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//    }
//
//    override func layoutSubviews() {
//
//        transactionView.text = "еуые"
//        //        print(String(Substring(currentTransaction.currency.rawValue)))
//        currencyImageView.image = UIImage(named: "Bitcoin")
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}



