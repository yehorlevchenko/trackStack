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

    let baseUrl: String = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    var lastPrice: [String:Double] = [:]
    
    func getPrice(for currency: String) {
        let requestUrl: String = "\(baseUrl)\(currency)USD"
        
        Alamofire.request(requestUrl, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let rawData: JSON = JSON(response.result.value!)
                self.lastPrice[currency] = rawData["bid"].doubleValue
                print(self.lastPrice)
            }
            else {
                fatalError("Unable to load data")
            }
            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
            
            
        }
    }
}
