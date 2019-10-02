//
//  ChatApiClient.swift
//  MessageKit
//
//  Created by Suresh on 22/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

protocol ChatApiClientProtocol {
    func sendMessage(queryParam: [String:Any], completion: @escaping (Result<Chat, Error>) -> Void)
}

class ChatApiClient: ChatApiClientProtocol {
    private let networkService = NetworkService<ChatEndPoint>()
    
    func sendMessage(queryParam: [String:Any], completion: @escaping (Result<Chat, Error>) -> Void) {
        if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
            self.networkService.makeRequest(for: .sendMessage(parameter: queryParam)).mock()
                .execute(responseClassType: Chat.self, completion: completion)
        }else {
            self.networkService.makeRequest(for: .sendMessage(parameter: queryParam))//.mock()
                .execute(responseClassType: Chat.self, completion: completion)
        }
       
    }
}



