//
//  UsersApiClient.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation

protocol UsersApiClientProtocol {
    func fetchUsers(queryParam: [String:Any], completion: @escaping (Result<[User], Error>) -> Void)
}

class UsersApiClient: UsersApiClientProtocol {
    private let networkService = NetworkService<UsersEndPoint>()
    
    func fetchUsers(queryParam: [String:Any], completion: @escaping (Result<[User], Error>) -> Void) {
        
        if ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil {
            self.networkService.makeRequest(for: .fetchUserList(parameter: queryParam)).mock()
                .execute(responseClassType: [User].self, completion: completion)
        }else {
            self.networkService.makeRequest(for: .fetchUserList(parameter: queryParam))//.mock()
                .execute(responseClassType: [User].self, completion: completion)
        }
       
    }
}
