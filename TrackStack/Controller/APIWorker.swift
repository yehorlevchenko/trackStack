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
    
    var delegate: ContentShareable?
    
    let provider = MoyaProvider<Bitcoinaverage>()
    var rawData: JSON?
    
    func checkConnection() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func update(for currencyList: [Bitcoinaverage]) {
        for currency in currencyList {
            getPrice(for: currency)
        }
    }
    
    private func getPrice(for currency: Bitcoinaverage) {
        provider.request(currency) { result in
            switch result {
            case .success(let response):
                do {
                    try response.filterSuccessfulStatusCodes()
                    let data = try response.mapJSON()
                    self.unpackData(rawData: data)
                } catch {
                    
                }
            case .failure(let error):
                print(error.response!)
            }
        }
    }
    
    private func unpackData(rawData: Any) {
        let cleanData = JSON(rawData)
        
        if let currency = cleanData["display_symbol"].string {
            if let price = cleanData["bid"].double {
                let newData = [currency: price]
                print(newData)
                delegate?.receiveUpdate(data: newData)
            }
        }
    }
}
