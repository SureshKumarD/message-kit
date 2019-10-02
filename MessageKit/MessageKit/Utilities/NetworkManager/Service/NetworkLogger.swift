//
//  NetworkLogger.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/11.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

class NetworkLogger {
    static func log(request: URLRequest) {
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
    
    static func log(response: URLResponse?, responseData data: Data?) {
        guard let response = response,  let responseData = data else {
            print("Response or Data is nil")
            return
        }
        
        print("\n - - - - - - - - - - INCOMING - - - - - - - - - - \n")
        
        let output =
        """
        RESPONSE:\n \(response)\n
        """
        
        print(output)
        
        NetworkLogger.log(responseData: responseData)
    }
    
    static func log(responseData data: Data?) {
        guard let responseData = data else {
            print("Response or Data is nil")
            return
        }
        
        print("\n - - - - - - - - - - DATA - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        var output = ""
        output += (responseData.prettyPrintedJSONString ?? "") as String
        
        print(output)
    }
}
