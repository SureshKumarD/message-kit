//
//  ChatEndPoint.swift
//  MessageKit
//
//  Created by Suresh on 22/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

public enum ChatEndPoint {
    case sendMessage(parameter: [String:Any])
}

extension ChatEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .sendMessage:
            return "v1/chat/completions"
        }
    }
    
    var baseURL: URL {
        return URL(string: "https://api.openai.com")!
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization" : "Bearer <your-open-ai-api-key>",
                "Content-Type"  : "application/json"]
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var task: HTTPTask {
        switch self {
            
        case .sendMessage(let parameter):
            return.requestParameters(bodyParameters: parameter, bodyEncoding: .jsonEncoding, urlParameters: nil)
////            return .requestParameters(bodyParameters: nil,
//                                      bodyEncoding: .urlEncoding,
//                                      urlParameters: parameter)
            
        }
    }
    
    var mockFile: String? {
        switch self {
        case .sendMessage:
            return "sendMessage"
        }
    }
}

