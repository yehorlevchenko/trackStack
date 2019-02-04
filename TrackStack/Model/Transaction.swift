//
//  Transaction.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 1/30/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation

class Transaction {
    var currency: Currency
    var amount: Double // how much user bought
    var price: Double // what was the price of
    var market: String?
    var priceDiff: Double = 0    
    
    init(currency: Currency, amount: Double, price: Double, market: String = "") {
        self.currency = currency
        self.amount = amount
        self.price = price
        self.market = market
    }
    
    enum Currency: String {
        case Bitcoin
        case Litecoin
    }
}
