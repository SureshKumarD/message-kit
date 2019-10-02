//
//  BaseViewModel.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import Foundation
import UIKit

let PADDING : CGFloat = 16
class BaseViewModel {
    var viewState: Observable<ViewState> = Observable<ViewState>(.Loaded)
    
}
