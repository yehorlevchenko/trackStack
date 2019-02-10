//
//  Transaction.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 1/30/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation

class Transaction {
    let currency: Currency
    let amount: Double // how much user bought
    let priceOrigin: Double // what was the price of currency
    var priceCurrent: Double
    let market: String?
    var priceDiff: Double = 0
    
    init(currency: Currency, amount: Double, priceOrigin: Double, priceCurrent: Double, market: String = "") {
        self.currency = currency
        self.amount = amount
        self.priceOrigin = priceOrigin
        self.priceCurrent = priceCurrent
        self.market = market
    }
    
    enum Currency: String {
        case BTC
        case LTC
    }
}
