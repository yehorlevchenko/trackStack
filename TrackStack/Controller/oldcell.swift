//
//  TransactionCell.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 1/30/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation
import UIKit

class oldcell: UITableViewCell {
    
    var transaction: Transaction?
    
    var transactionView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var currencyImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(transactionView)
        self.addSubview(currencyImageView)
        
        currencyImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        currencyImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        currencyImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        currencyImageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        transactionView.leftAnchor.constraint(equalTo: self.currencyImageView.rightAnchor).isActive = true
        transactionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        transactionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        transactionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        if let currentTransaction = transaction {
            transactionView.text = "\(currentTransaction.amount) for \(currentTransaction.priceOrigin)"
            print(String(Substring(currentTransaction.currency!)))
            currencyImageView.image = UIImage(named: String(Substring(currentTransaction.currency!)))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
