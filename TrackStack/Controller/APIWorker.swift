//
//  Network.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 2/9/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIWorker {

    let baseUrl: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/all?crypto=BTC&fiat=USD,EUR"
    var lastCurrencyData: [String:Any]?
    
    func checkConnection() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func getPrice(for currency: String) {
        let requestUrl: String = "\(baseUrl)"
        var rawData: JSON?
        
        Alamofire.request(requestUrl, method: .get).validate().responseJSON { response in
            print("Getting data")
            if response.result.isSuccess {
                print("Data received")
                if let data = response.result.value {
                    rawData = JSON(data)
                    print("Last Price updated")
                    self.unpackData(for: currency, from: rawData!)
                }
            }
        }
    }
    
    func unpackData(for currency: String, from data: JSON) {
        var newCurrencyData: [String:Any] = [:]
        newCurrencyData["ticker"] = currency
        newCurrencyData["price"] = data["bid"].doubleValue
        newCurrencyData["date"] = data["display_timestamp"].stringValue
        
        lastCurrencyData = newCurrencyData
    }
}
