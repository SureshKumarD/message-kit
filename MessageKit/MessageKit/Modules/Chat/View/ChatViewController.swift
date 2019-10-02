//
//  ChatViewController.swift
//  MessageKit
//
//  Created by Suresh on 22/09/19.
//  Copyright © 2019 self. All rights reserved.
//

import UIKit

class ChatViewController: BaseController {
    
    private var viewModel : ChatViewModel?

    private let footerViewDefaultHeight : CGFloat = 80
    
    private let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let footerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(hexString: "#f0eff4")
        return view
    }()
    
    private let textView : CustomTextView = {
        let textView = CustomTextView(textStyle: .footnote)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.set(cornerRadius: 16, borderWidth: 1.0, borderColor: .gray)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private var footerViewHeightConstraint: NSLayoutConstraint?
    
    private let sendButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 14)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(send(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    init(user: User?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ChatViewModel(user: user, delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationItem.title = self.viewModel?.navigationTitle
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Assuming there is width constraint setup on the textView.
        let targetSize = CGSize(width: textView.frame.width, height: CGFloat(MAXFLOAT))
        let textViewDeltaHeight = (textView.sizeThatFits(targetSize).height - 30.0)
        if textViewDeltaHeight > 0.0 {
            let maxHeight : CGFloat = 300
            footerViewHeightConstraint?.constant = min(footerViewDefaultHeight + textViewDeltaHeight, maxHeight)
            textView.isScrollEnabled = (footerViewHeightConstraint?.constant == maxHeight) ?  true : false
        }else {
            footerViewHeightConstraint?.constant = footerViewDefaultHeight
            textView.isScrollEnabled = false
        }
        
    }

}

extension ChatViewController {
    
    func setupViews() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        containerView.alignEdges(to: self.view)
        
        containerView.addSubview(footerView)
        footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        footerViewHeightConstraint = footerView.heightAnchor.constraint(equalToConstant: footerViewDefaultHeight)
        footerViewHeightConstraint?.isActive = true
       
        
        //CollectionView
        containerView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
       
        collectionView.allowsSelection = false
        collectionView.contentInset = UIEdgeInsets(top: 2*PADDING, left: 0, bottom: 2*PADDING, right: 0)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: String(describing: ChatCell.self))
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        
    
        //FooterView
        footerView.addSubview(sendButton)
        sendButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -PADDING/2).isActive = true

        footerView.addSubview(textView)
        textView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: PADDING).isActive = true
        textView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: PADDING).isActive = true
        textView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -2*PADDING).isActive = true
        textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: PADDING/2).isActive = true
        textView.delegate = self
        textView.text = ""
         _ = textView(textView, shouldChangeTextIn: NSRange(location: 0, length: 0), replacementText: "")
        sendButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true
        
      
        
        self.setViewStateBinding(viewModel: self.viewModel)
        self.setSendButtonBinding()
    }
    
    @objc func send(_ sender : UIButton?) {
        let message = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        viewModel?.conversation(message: message)
        viewModel?.sendMessage(message: message)
        textView.text = ""
        _ = textView(textView, shouldChangeTextIn: NSRange(location: 0, length: 0), replacementText: "")
        footerViewHeightConstraint?.constant = footerViewDefaultHeight
        view.endEditing(true)
    }

}

extension ChatViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfMessages(messages: viewModel?.getMessages()) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let chatCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ChatCell.self), for: indexPath) as! ChatCell
        let chat = viewModel?.getMessages()[indexPath.row]
        
        let estimatedSize = self.viewModel?.getSize(for: chat?.payload?.chatMessage, defaultSize: CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude), font: ChatViewModel.messageFont) ?? CGSize.zero
        chatCell.configure(chat: chat, estimatedSize: estimatedSize, screenWidth: collectionView.frame.size.width)
        
        return chatCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = viewModel?.getMessages()[indexPath.row]

        let estimatedSize = self.viewModel?.getSize(for: message?.payload?.chatMessage, defaultSize: CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude), font: ChatViewModel.messageFont) ?? CGSize.zero
        return CGSize(width: collectionView.frame.size.width, height: estimatedSize.height + 32 + 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

}

extension ChatViewController : UITextViewDelegate {
    private func setSendButtonBinding() {
        viewModel?.shouldEnableSendButton.bind = { state in
            self.sendButton.isEnabled =  state
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        viewModel?.shouldEnableSendButton.value =  updatedText.count > 0
        
        if updatedText.isEmpty {
            textView.text = "Aa"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.init(hexString: "#666666")
            textView.text = ""
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

extension ChatViewController : ChatViewDelegate {
    func insertMessageOnUI() {
        if let itemsCount = self.viewModel?.getMessages().count {
            let lastItemIndex = itemsCount - 1
            let indexPath = IndexPath(item: lastItemIndex, section: 0)
            collectionView.insertItems(at: [indexPath])
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
        }
        
       
    }
}
