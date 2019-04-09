//
//  APIWorker.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 2/9/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Moya

class APIWorker {
    
    enum State {
        case idle
        case processing
        case ready
    }
    
    let currencyConverter = ["BTC": Bitcoinaverage.BTCUSD, "LTC": Bitcoinaverage.LTCUSD]
    let provider = MoyaProvider<Bitcoinaverage>()
    var state: State = .idle
    var currencyData = [String:Double]() {
        didSet {
            self.state = .ready
            print("APIWorker is ready: \(currencyData)")
        }
    }
    var rawData: JSON? {
        didSet {
            do {
                self.currencyData = try self.unpackData()
            } catch {
                print(error)
            }
            
        }
    }
    
    
    func checkConnection() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func update(for currencyList: [String]) {
        self.state = .processing
        for currency in currencyList {
            let convertedCurrency: Bitcoinaverage = currencyConverter[currency]!
            getPrice(for: convertedCurrency)
        }
    }
    
    private func getPrice(for currency: Bitcoinaverage) {
        
        provider.request(currency) { result in
            switch result {
            case .success(let response):
                do {
                    self.rawData = try JSON(response.mapJSON())
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error.response!)
            }
        }
    }
//    private func getPrice(for currency: String) -> JSON {
//        let requestUrl: String = baseUrl + currency + "USD"
//        var rawData: JSON?
//
//        Alamofire.request(requestUrl, method: .get).validate().responseJSON { response -> JSON in
//            print("Getting data")
//            if response.result.isSuccess {
//                print("Data received")
//                if let data = response.result.value {
//                    rawData = JSON(data)
////                    self.unpackData(for: currency, from: rawData!)
//                    return rawData
//                }
//            }
//        }
//    }

//    func unpackData(for currency: String, from data: JSON) {
//        var newCurrencyData: [String:Any] = [:]
//        newCurrencyData["ticker"] = currency
//        newCurrencyData["price"] = data["bid"].doubleValue
//
//        currencyData = newCurrencyData
//    }
    
    private func unpackData() throws -> [String:Double] {
        guard let currency = rawData!["disply_symbol"].string else {
            throw DataError.noDisplaySymbol
        }
        guard let price = rawData!["bid"].double else {
            throw DataError.noBid
        }
        
        var newData = [currency: price]
        return newData
    }
}

enum DataError: Error {
    case noDisplaySymbol
    case noBid
}
