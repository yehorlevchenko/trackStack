//
//  TransactionCell.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 2/4/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import UIKit
import SwipeCellKit

class TransactionCell: SwipeTableViewCell {
    
    var transaction: Transaction?
    
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionCurrencyImage: UIImageView!
    @IBOutlet weak var transactionPriceDiff: UIImageView!
    
    func setTransaction(data: Transaction) {
        transactionAmountLabel.text = "\(data.amount): \(data.priceOrigin) / \(data.priceCurrent)"
        transactionCurrencyImage.image = UIImage(named: String(data.currency.rawValue))
        transactionPriceDiff.image = data.priceOrigin > data.priceCurrent ? UIImage(named: "priceDown") : UIImage(named: "priceUp")
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



