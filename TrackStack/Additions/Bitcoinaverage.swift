//
//  Bitcoinaverage.swift
//  TrackStack
//
//  Created by Yehor Levchenko on 4/9/19.
//  Copyright © 2019 Yehor Levchenko. All rights reserved.
//

import Foundation
import Moya

public enum Bitcoinaverage {
    case BTC
    case LTC
}

extension Bitcoinaverage: TargetType {
    public var baseURL: URL {
        return URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker")!
    }
    
    public var path: String {
        switch self {
        case .BTC: return "/BTCUSD"
        case .LTC: return "/LTCUSD"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .BTC: return .get
        case .LTC: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .BTC: return .requestPlain
        case .LTC: return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
