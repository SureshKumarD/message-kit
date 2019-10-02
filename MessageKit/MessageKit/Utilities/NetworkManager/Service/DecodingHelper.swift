//
//  DecodingHeloer.swift
//  Connect
//
//  Created by Suresh on 08/08/19.
//  Copyright © 2019 Lenskart. All rights reserved.
//

import Foundation

//https://gist.github.com/aunnnn/9a6b4608ae49fe1594dbcabd9e607834
struct DecodingHelper {
    private static let modelKey = "my_model_key"
    
    private struct Key: CodingKey {
        let stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        let intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    private struct ModelResponse<NestedModel: Decodable>: Decodable {
        let nested: NestedModel
        
        public init(from decoder: Decoder) throws {
            // Split nested paths with '.'
            var keyPaths = (decoder.userInfo[CodingUserInfoKey(rawValue: modelKey)!]! as! String).split(separator: ".")
            
            // Get last key to extract in the end
            let lastKey = String(keyPaths.popLast()!)
            
            // Loop getting container until reach final one
            var targetContainer = try decoder.container(keyedBy: Key.self)
            for k in keyPaths {
                let key = Key(stringValue: String(k))!
                targetContainer = try targetContainer.nestedContainer(keyedBy: Key.self, forKey: key)
            }
            nested = try targetContainer.decode(NestedModel.self, forKey: Key(stringValue: lastKey)!)
        }
    }
    
    static func decode<T: Decodable>(modelType: T.Type, fromData data: Data, forKey key: String? = nil) throws -> T {
        let decoder = JSONDecoder()
        
        if let unwrappedKey = key {
            decoder.userInfo[CodingUserInfoKey(rawValue: modelKey)!] = unwrappedKey
            return try decoder.decode(ModelResponse<T>.self, from: data).nested
        }else {
            return try decoder.decode(T.self, from: data)
        }
    }
    
    static func encode<T:Encodable>(modelObject:T) throws -> Any {
        let jsonData = try JSONEncoder().encode(modelObject)
        
        let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
        return json
    }
}
