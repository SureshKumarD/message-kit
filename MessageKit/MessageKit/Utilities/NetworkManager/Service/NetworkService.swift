//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/07.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol: class {
    associatedtype EndPoint: EndPointType
    
    func execute<T:Decodable>(responseClassType:T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func cancel()
}


class NetworkService<EndPoint: EndPointType>: NetworkServiceProtocol {
    
    private let session: URLSession
    private let deliveryOn: DispatchQueue
    
    private var task: URLSessionTask?
    private var mockedData: Data?
    private var request: URLRequest?
    private var route: EndPoint?
    private var response: URLResponse?
    
    init(session: URLSession = URLSession.shared,
         deliveryOn: DispatchQueue = DispatchQueue.main) {
        self.session = session
        self.deliveryOn = deliveryOn
    }
    
    @discardableResult
    func makeRequest(for route:EndPoint) -> NetworkService {
        
        self.route = route
        
        do {
            self.request = try self.buildRequest(from: route)
            NetworkLogger.log(request: self.request!)
        }catch let error {
            print(error)
        }
        return self
    }
    
    @discardableResult func mock() -> NetworkService {
        
        guard let data = ResponseProvider.mock(fileName: self.route?.mockFile), data.count > 0 else {
            print("Unable to mock response from file, Make sure the filename and extension are correct, and the file is present in the main bundle of your app. Also make sure the file is not empty.")
            return self
        }
        
        self.mockedData = data
        return self
    }
    
    
    func execute<T>(responseClassType:T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
        self.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.handleSuccessResponse(with: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func execute(completion: @escaping (Result<Data, Error>) -> Void) {
        
        
        #if ENV_DEV
        guard mockedData == nil else {
            print("Data Fetched From Mock File")
            NetworkLogger.log(responseData: mockedData)
            completion(.success(mockedData!))
            self.mockedData = nil
            return
        }
        #endif
        
        task = self.session.dataTask(with: request!, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            NetworkLogger.log(response: response, responseData: data)
            self.response = response
            
            let resultStatus = self.handleNetworkResponse(response, data: data,error: error)
            
            self.deliveryOn.async {
                switch resultStatus {
                case .success:
                    completion(.success(data!))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        })
        
        self.task?.resume()
    }
    
    
    @discardableResult
    func getResponse() -> URLResponse? {
        return response
    }
    
    func cancel() {
        self.task?.cancel()
    }
}

extension NetworkService {
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path))
        
        request.httpMethod = route.httpMethod.rawValue
        request.allHTTPHeaderFields = route.headers
        
//        if let accessToken = LKBussinessUser.current()?.session.accessToken {
//            request.addValue(accessToken, forHTTPHeaderField: LKPOSXSESSIONTOKEN)
//        }
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func handleSuccessResponse<T:Decodable>(with data:Data?,  completion: @escaping (Result<T, Error>) -> Void) {
        guard let data = data else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        deliveryOn.async {
            do {
                let responseObject: T = try ResponseParser.handleResponse(with: data)
                completion(.success(responseObject))
            }catch {
                completion(.failure(error))
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ urlResponse: URLResponse?,data: Data?, error: Error?) -> Result<Bool,Error> {
        
        //Server throw error, return early
        if let error = error {
            return .failure(error)
        }
        
        guard let httpURLResponse = urlResponse as? HTTPURLResponse,
            let data = data else {return .failure(NetworkError.noData)}
        
        switch httpURLResponse.statusCode {
            
        case 200...299:
            return .success(true)
            
        case 401...600:
            do {
                let errorObject = try DecodingHelper.decode(modelType: NetworkError.self, fromData: data)
                return .failure(errorObject)
            }catch let error {
                return .failure(error)
            }
            
        default:
            return .failure(NetworkError.Unknown)
        }
    }
}
