//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

let baseUrl = "https://api.github.com/"

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var mockFile:String? {get}
}

extension EndPointType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return getDefaultHeaders()
    }
    
    var mockFile:String? {
        return nil
    }
    
    func getDefaultHeaders() -> HTTPHeaders? {
        return [ "Content-Type"  : "application/json"]

    }
}
