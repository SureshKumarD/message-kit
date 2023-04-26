//
//  ChatMessage.swift
//  MessageKit
//
//  Created by Suresh on 22/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation

final class Chat: Decodable {
    var id: String?
    var object: String?
    var created: TimeInterval?
    var model: String?
    var usage: Usage?
    var choices: [Choice]?
    var isReceived: Bool = true
    init(isReceived: Bool) {
        self.isReceived = isReceived
        
    }
    
   
    
    enum CodingKeys : String, CodingKey {
        case id, object, created, model, usage, choices
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String.self, forKey: .id)
        object = try? container.decode(String.self, forKey: .object)
        created = try? container.decode(TimeInterval.self, forKey: .created)
        model = try? container.decode(String.self, forKey: .model)
        usage = try? container.decode(Usage.self, forKey: .usage)
        choices = try container.decode([Choice].self, forKey: .choices)
        
    }
     

}

final class Choice: Decodable {
    var message: Message?
    var finishReason: String?
    var index : Int?
    
    init() {
    }

    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
        case index
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try? container.decode(Message.self, forKey: .message)
        finishReason = try? container.decode(String.self, forKey: .finishReason)
        index = try? container.decode(Int.self, forKey: .index)
    }
   
}

final class Usage: Decodable {
    var totalTokens, completionTokens, promptTokens: Int?
    enum CodingKeys: String, CodingKey {
        case totkenTokens = "total_tokens"
        case completionTokens = "completion_tokens"
        case promptTokens = "prompt_tokens"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalTokens = try? container.decode(Int.self, forKey: .totkenTokens)
        completionTokens = try? container.decode(Int.self, forKey: .completionTokens)
        promptTokens = try? container.decode(Int.self, forKey: .promptTokens)
    }
   
}

final class Message: Decodable {
    var content, role: String?
    
    init(content: String?, role: String?) {
        self.content = content
        self.role = role
    }
    
    enum CodingKeys: String, CodingKey {
        case content, role
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try? container.decode(String.self, forKey: .content)
        role = try? container.decode(String.self, forKey: .role)
    }
   
}

