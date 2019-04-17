//
//  Transaction+CoreDataClass.swift
//  
//
//  Created by Yehor Levchenko on 4/17/19.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    public func countDiff() {
        let diff = (self.priceLast - self.priceOrigin) / self.priceOrigin
        if diff > 0.001 {
            self.priceDiff = diff * 100
        } else {
            self.priceDiff = 0.0
        }
    }
}
