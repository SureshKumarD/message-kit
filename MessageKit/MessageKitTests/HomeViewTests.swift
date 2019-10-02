//
//  HomeViewTests.swift
//  MessageKitTests
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import XCTest
@testable import MessageKit

class HomeViewTest: XCTestCase {
    private var viewModel: HomeViewModel?
    let usersApiClient : UsersApiClientProtocol = UsersApiClient()
    var users : [User]?

    override func setUp() {
        viewModel = HomeViewModel(since: "135")
        
       
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testUserList() {
        // Assert
        self.usersApiClient.fetchUsers(queryParam: [:]) {[weak self] (result: Result<[User], Error>) in
            guard let weakSelf = self else {
                return
            }
            switch result {
            case .success(let users):
                weakSelf.users = users
                XCTAssert(weakSelf.viewModel?.getNumberOfItems(users: weakSelf.users) ?? 0 > 0, "Number of users cannot be empty")
                
            case .failure(let error):
                print(error)
               XCTAssertNil(weakSelf.users)
            }
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
