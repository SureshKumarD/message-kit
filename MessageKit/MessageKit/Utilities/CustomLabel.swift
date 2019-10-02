//
//  CustomLabel.swift
//  MessageKit
//
//  Created by Suresh on 21/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    init(textStyle: UIFont.TextStyle, frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.font = ScaledFont.shared.font(forTextStyle: textStyle)
        self.textColor = ScaledFont.shared.getTextColor(forTextStyle: textStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let textStyleString = self.font.fontDescriptor.fontAttributes[.textStyle] as? String {
            let textStyle = UIFont.TextStyle(rawValue: textStyleString)
            
            self.font = ScaledFont.shared.font(forTextStyle: textStyle)
            self.textColor = ScaledFont.shared.getTextColor(forTextStyle: textStyle)
        }
    }
}

class CustomTextView: UITextView {

    init(textStyle: UIFont.TextStyle, frame: CGRect = .zero, textContainer : NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        self.font = ScaledFont.shared.font(forTextStyle: textStyle)
        self.textColor = ScaledFont.shared.getTextColor(forTextStyle: textStyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let textStyleString = self.font?.fontDescriptor.fontAttributes[.textStyle] as? String {
            let textStyle = UIFont.TextStyle(rawValue: textStyleString)
            
            self.font = ScaledFont.shared.font(forTextStyle: textStyle)
            self.textColor = ScaledFont.shared.getTextColor(forTextStyle: textStyle)
        }
    }
}
