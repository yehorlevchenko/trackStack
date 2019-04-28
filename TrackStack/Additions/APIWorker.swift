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
    let provider = MoyaProvider<Bitcoinaverage>()
    var delegate: ContentShareable?
    var currency: String = FiatCurrency.USD.rawValue
    var requestedDataCount = 0
    var rawData: JSON?
    var preparedData = [String:Double]()
    
    private enum ErrorHandler: String {
        case networkError = "Unable to reach out data source. Check your connection."
        case responseError = "No response from data source. Try again later."
    }
    
    func checkConnection() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func update(for currencyList: [Bitcoinaverage]) {
        requestedDataCount = currencyList.count
        for currency in currencyList {
            getPrice(for: currency)
        }
    }
    
    private func getPrice(for currency: Bitcoinaverage) {
        provider.request(currency) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.mapJSON()
                    self.unpackData(rawData: data)
                } catch {
                    print("/// Network error: \(error)")
                    self.delegate?.failedUpdate(reason: ErrorHandler.networkError.rawValue)
                }
            case .failure(let error):
                print("/// No response: \(error)")
                self.delegate?.failedUpdate(reason: ErrorHandler.responseError.rawValue)
            }
        }
    }
    
    private func unpackData(rawData: Any) {
        let cleanData = JSON(rawData)
        
        if let currency = cleanData["display_symbol"].string {
            if let price = cleanData["bid"].double {
                preparedData.updateValue(price, forKey: currency)
                
                if preparedData.count == requestedDataCount {
                    delegate?.receiveUpdate(data: preparedData)
                }
            }
        }
    }
}
