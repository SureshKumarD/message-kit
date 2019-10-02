//
//  NetworkError.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

public enum NetworkError : Error, Decodable {
    case parametersNil
    case encodingFailed
    case missingURL
    case noData
    case Unknown
    case Custom(ServerError)
    case CustomMessage(String)
    
    enum CodingKeys: String, CodingKey {
        case errors
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NetworkError.CodingKeys.self)
        if let serverErrorArray = try container.decodeIfPresent([ServerError].self, forKey: .errors),
            let serverError = serverErrorArray.first {
            self = .Custom(serverError)
        }else {
            throw NetworkError.Unknown
        }
    }
    
    public struct ServerError: Decodable {
        var errorCode: Int?
        var errorMessage: String?
        
        enum CodingKeys: String, CodingKey {
            case errorCode = "errorCode"
            case errorMessage = "errorMessage"
            case field = "field"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            errorCode = try? container.decode(Int.self, forKey: .errorCode)
            
            if let codeString = try? container.decode(String.self, forKey: .errorCode),
                let codeInt = Int(codeString) {
                errorCode = codeInt
            }
            
            let errorMessage = try (container.decodeIfPresent(String.self, forKey: .errorMessage) ?? container.decodeIfPresent(String.self, forKey: .field))
            self.errorMessage = errorMessage
        }
    }
}

extension NetworkError {
    var localizedMessage: String {
        switch self {
            
        case .parametersNil:
            return "Parameters were nil."
            
        case .encodingFailed:
            return "Parameter encoding failed."
            
        case .missingURL:
            return "URL is nil."
            
        case .noData:
            return "No Data"
            
        case .Unknown:
            return "Unknown"
            
        case .Custom(let serverError):
            return serverError.errorMessage ?? ""
            
        case .CustomMessage(let message):
            return message
        }
    }
}

extension Error {
    var localizedMessage: String {
        switch self  {
        case let error as NetworkError:
            return error.localizedMessage
        default:
            return self.localizedDescription
        }
    }
}
