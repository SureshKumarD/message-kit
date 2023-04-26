//
//  HomeViewController.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

final class HomeViewController: BaseController {
    
    private var viewModel : HomeViewModel?
    
    private let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = HomeViewModel(since: "135", delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    
        viewModel?.fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = self.viewModel?.navigationTitle
    }
    
    func setupViews() {
        

        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .black
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(containerView)
        containerView.alignEdges(to: self.view)
        
        containerView.addSubview(collectionView)
        collectionView.alignEdges(to: containerView)
        collectionView.allowsSelection = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: String(describing: UserCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.setViewStateBinding(viewModel: self.viewModel)
    }
    
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let usersCount = self.viewModel?.getUsers().count {
            return usersCount
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UserCell.self), for: indexPath) as! UserCell
        let user = self.viewModel?.getUsers()[indexPath.row]
        userCell.configure(user: user)
        return userCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 4*PADDING)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PADDING
    }
    
    
}

extension HomeViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = viewModel?.getUsers()[indexPath.row]
        openChatViewController(user: user)
    }
    
    private func openChatViewController(user: User?) {
        let chatViewController = ChatViewController(user: user)
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}

extension HomeViewController : HomeViewDelegate {
    func usersFetched() {
        collectionView.reloadData()

    }
    
    
}

