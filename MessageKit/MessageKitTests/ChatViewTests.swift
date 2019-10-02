//
//  ChatViewTests.swift
//  MessageKitTests
//
//  Created by Suresh on 26/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import XCTest

class ChatViewTests: XCTestCase {

    private let viewModel = ChatViewModel(user: nil)
    private let chatApiClient : ChatApiClientProtocol = ChatApiClient()
    private var messages : [Chat] = []
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSendMessage() {
        // Assert
        
        self.chatApiClient.sendMessage(queryParam: [:]) {[weak self] (result: Result<Chat, Error>) in
            guard let weakSelf = self else {
                return
            }
            
            switch result {
            case .success(let chat):
                weakSelf.messages.append(chat)
                XCTAssertNil(weakSelf.viewModel.numberOfMessages(messages: weakSelf.messages) > 0, "Number of messages cannot be empty")
                let estimatedSize = self?.viewModel.getSize(for: chat.payload?.chatMessage, defaultSize: CGSize(width: 250, height: 1000), font: ChatViewModel.messageFont)
                XCTAssert(estimatedSize!.width > CGFloat(0), "Estimated width cannot be 0 or lesser.")
                XCTAssert(estimatedSize!.height > CGFloat(0), "Estimated height cannot be 0 or lesser.")
            case .failure(_):
                XCTAssertNil(weakSelf.messages)
            }
        }
    
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
