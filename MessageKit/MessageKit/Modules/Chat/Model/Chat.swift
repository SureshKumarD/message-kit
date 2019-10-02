//
//  ChatMessage.swift
//  MessageKit
//
//  Created by Suresh on 22/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

final class Chat: Decodable {

    var isReceiver      : Bool = true
    var timeStampString : String?
    var result          : ChatResult?

    lazy var payload  : ChatPayload? = {
        self.isReceiver = true
        let message = result?.fullFillMent?.messages?.filter{ $0.payload != nil }.first
        return message?.payload
        
    }()
    
    enum CodingKeys : String, CodingKey {
        case timeStampString = "timestamp"
        case result = "result"
    }

}

final class ChatResult : Decodable {
    var action       : String?
    var fullFillMent : ChatFullFillMent?
    enum CodingKeys : String, CodingKey {
        case action = "action"
        case fullFillMent = "fulfillment"
    }
}

final class ChatFullFillMent : Decodable {
    var messages    : [Message]?
    enum CodingKeys : String, CodingKey {
        case messages = "messages"
    }
    
}


final class Message: Decodable {
    var payload : ChatPayload?
    enum CodingKeys : String, CodingKey {
        case payload = "payload"
    }
}


open class ChatPayload: Decodable {
    var chatMessage       : String?
    enum CodingKeys : String, CodingKey {
        case chatMessage = "defaultReply"
    }
}
