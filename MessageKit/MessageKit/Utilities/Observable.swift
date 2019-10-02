//
//  Observable.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation

protocol Observer {
    associatedtype T
    var bind :((T) -> ())? {get set}
}

class Observable<T>:Observer {
    var bind: ((T) -> ())? = {_ in}
    
    var value :T? {
        didSet {
            if let value = value{
                bind?(value)
            }
        }
    }
    
    init(_ v :T? = nil) {
        value = v
        
    }
    
}
