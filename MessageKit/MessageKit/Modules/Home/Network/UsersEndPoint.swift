//
//  UsersEndPoint.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation

public enum UsersEndPoint {
    case fetchUserList(parameter: [String:Any])
}

extension UsersEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .fetchUserList:
            return "users"
        }
    }
    
    var task: HTTPTask {
        switch self {
            
        case .fetchUserList(let parameter):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: parameter)
            
        }
    }
    
    var mockFile: String? {
        switch self {
        case .fetchUserList:
            return "userList"
        }
    }
}
