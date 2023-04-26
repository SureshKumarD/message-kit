//
//  UserCell.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

final class UserCell: BaseCell {
    
    private let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 3.0
        return imageView
        
    }()
    
    private let userNameLabel : UILabel = {
        let label = CustomLabel(textStyle: .title3)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let disclosureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 3.0
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysOriginal).withTintColor(.black)
        
        return imageView
    }()
    
    private let separatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        return view
        
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        self.contentView.addSubview(containerView)
        containerView.alignEdges(to: self.contentView)
        
        containerView.addSubview(userImageView)
        userImageView.pinToLeft(to: containerView, top: PADDING/2, left: PADDING, bottom: PADDING/2, width: PADDING*3)
        
        containerView.addSubview(disclosureImageView)
        disclosureImageView.pinToRight(to: containerView, top: PADDING, bottom: PADDING, right: PADDING, width: PADDING*3)
        
        containerView.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: PADDING/2.0).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -PADDING/2.0).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant:  PADDING/2.0).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: disclosureImageView.leadingAnchor, constant: -PADDING/2.0).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        
        containerView.addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        

    }
    
}

extension UserCell {
    func configure(user: User?) {
        self.userImageView.load(url: URL(string: user?.avatarUrl ?? "")!)
        if let userName = user?.login {
            
            self.userNameLabel.text = "@\(userName)"
        
        }else {
            self.userNameLabel.text = "@user"
        }
    }
}


