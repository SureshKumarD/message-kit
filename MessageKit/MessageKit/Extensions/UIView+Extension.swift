//
//  UIView+Extension.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

extension UIView {
    
    func alignEdges(to otherView: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -insets.bottom),
            self.leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -insets.right)
            ])
    }
    
    func pinToTop(to otherView: UIView, top: CGFloat, left: CGFloat, right: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: top),
            self.leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: left),
            self.trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -right),
            self.heightAnchor.constraint(equalToConstant: height)
            ])
    }
    
    func pinToBottom(to otherView: UIView, left: CGFloat, bottom: CGFloat, right: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: left),
            self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -bottom),
            self.trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -right),
            self.heightAnchor.constraint(equalToConstant: height)
            ])
    }
    
    func pinToLeft(to otherView: UIView, top: CGFloat, left: CGFloat, bottom: CGFloat, width: CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: top),
            self.leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: left),
            self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -bottom),
            self.widthAnchor.constraint(equalToConstant: width)
            ])
    }
    
    func pinToRight(to otherView: UIView, top: CGFloat, bottom: CGFloat, right: CGFloat, width: CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: otherView.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -bottom),
            self.trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -right),
            self.widthAnchor.constraint(equalToConstant: width)
            ])
    }
}



extension UIView {
    
    func set(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius  = cornerRadius
        self.layer.borderWidth   = borderWidth
        self.layer.borderColor   = borderColor.cgColor
        self.layer.masksToBounds = true
    }
    

}
