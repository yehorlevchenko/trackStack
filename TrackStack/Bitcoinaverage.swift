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
    case BTCUSD
    case LTCUSD
}

extension Bitcoinaverage: TargetType {
    public var baseURL: URL {
        return URL(string: "https://apiv2.bitcoinaverage.com/indices/global/ticker")!
    }
    
    public var path: String {
        switch self {
        case .BTCUSD: return "/BTCUSD"
        case .LTCUSD: return "/LTCUSD"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .BTCUSD: return .get
        case .LTCUSD: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .BTCUSD: return .requestPlain
        case .LTCUSD: return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
