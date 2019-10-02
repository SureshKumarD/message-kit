//
//  HomeViewModel.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit


protocol HomeViewDelegate {
    func usersFetched()
    
}


final class HomeViewModel : BaseViewModel {
    
    private var usersApiClient: UsersApiClientProtocol?
    private var sinceString : String?
    private var users : [User]? {
        didSet {
            self.homeViewDelegate?.usersFetched()
        }
    }
    lazy var navigationTitle : String = {
        return "GitHub DM"
    }()
    private var homeViewDelegate : HomeViewDelegate?
    
    init(since: String?, delegate: HomeViewDelegate? = nil, apiClient: UsersApiClientProtocol = UsersApiClient()) {
        super.init()
        self.sinceString = since
        self.usersApiClient = apiClient
        self.homeViewDelegate = delegate
    }
   
}

extension HomeViewModel {
    func fetchUsers() {
        self.viewState.value = .Loading
        let params = ["since" : self.sinceString ?? ""] as [String : Any]
        self.usersApiClient?.fetchUsers(queryParam: params) {[weak self] (result: Result<[User], Error>) in
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.viewState.value = .Loaded
            
            switch result {
            case .success(let users):
                weakSelf.users = users
            
            case .failure(let error):
                print(error)
                weakSelf.viewState.value = .Error(error)
            }
        }
    }
    
}

extension HomeViewModel {
    func getUsers() -> [User] {
        return self.users ?? []
    }
    
    func getNumberOfItems(users : [User]?) -> Int! {
        return users?.count ?? 0
    }
    
    func cellHeight() -> CGFloat {
        return PADDING * 6.0
    }
}
