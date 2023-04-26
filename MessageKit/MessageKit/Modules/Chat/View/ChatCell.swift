//
//  ChatCell.swift
//  MessageKit
//
//  Created by Suresh on 22/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

final class ChatCell: BaseCell {
    
    private let bubbleImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
   
    private let messageTextView : UITextView = {
        let textView = CustomTextView(textStyle: .caption1)
        textView.textAlignment = .left
        textView.textColor = UIColor.white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    private var leftBubbleImage : UIImage? = {
        let image = UIImage(named: "left_bubble")
        return image?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch).withRenderingMode(.alwaysOriginal) ?? nil
    }()
    
    private var rightBubbleImage : UIImage? = {
        let image = UIImage(named: "right_bubble")
        return image?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch).withRenderingMode(.alwaysOriginal) ?? nil
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        addSubview(bubbleImageView)
        addSubview(messageTextView)
    }
}

extension ChatCell {

    //ConfigureCell
    func configure(chat: Chat?, estimatedSize: CGSize, screenWidth: CGFloat) {
        messageTextView.text = chat?.choices?.first?.message?.content ?? ""
        if chat?.isReceived == false {
            bubbleImageView.image = rightBubbleImage
            messageTextView.frame = CGRect(x: screenWidth - estimatedSize.width - 32 - 32, y: 32, width: estimatedSize.width + 32, height: estimatedSize.height + 16)
            bubbleImageView.frame = CGRect(x: screenWidth - estimatedSize.width - 32 - 32 - 16, y: 16, width: estimatedSize.width + 32 + 32, height: estimatedSize.height + 16 + 32)
            
        }else {
            bubbleImageView.image = leftBubbleImage
            messageTextView.frame = CGRect(x: 32, y: 32, width: estimatedSize.width + 32, height: estimatedSize.height + 16)
            bubbleImageView.frame = CGRect(x: 16, y: 16, width: estimatedSize.width + 32 + 32, height: estimatedSize.height + 16 + 32)
        }
    
    }
    
}

