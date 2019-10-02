//
//  ResponseProvider.swift
//  Connect
//
//  Created by Pavan Gopal on 14/08/19.
//  Copyright © 2019 Lenskart. All rights reserved.
//

import Foundation

class ResponseProvider {
    
   class func mock(fileName: String?, fileType: String = "json") -> Data? {
        guard let fileName = fileName, let path = Bundle.main.path(forResource: fileName, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)), data.count > 0 else {
            print("Unable to mock response from file, Make sure the filename and extension are correct, and the file is present in the main bundle of your app. Also make sure the file is not empty.")
            return nil
        }
        
        return data
    }

}


class ResponseParser {
    
    class func handleResponse<T:Decodable>(with data:Data?, forKey: String? = nil) throws -> T {
        guard let data = data else {
            throw NetworkError.noData
        }
        
        do {
            let responseObject: T = try DecodingHelper.decode(modelType: T.self, fromData: data, forKey: forKey)
            return responseObject
        }catch {
            throw error
        }
        
    }
    
    class func serializeJSON<T>(with data: Data?) throws -> T {
        guard let data = data else {
            throw NetworkError.noData
        }
        
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? T {
            return json
        }else{
            throw NetworkError.noData
        }
    }
}
