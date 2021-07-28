//
//  CustomInputAccessoryView.swift
//  FireChat
//
//  Created by Nikhil Gharge on 08/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit

protocol CustomInputAccessoryViewDelegate: class {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String)
}

class CustomInputAccessoryView: UIView {
    
    // Mark: Properties
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    
    public lazy var messageInputView: UITextView = {
      let messageInpView = UITextView()
      messageInpView.font = UIFont.systemFont(ofSize: 14)
      messageInpView.isScrollEnabled = false
      return messageInpView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.systemPurple, for: .normal)
        button.addTarget(self, action:#selector(handleSendMesssage), for:.touchUpInside)
        return button
    }()
    
    private let placeHolder: UILabel = {
        let placeHolderLbl = UILabel()
        placeHolderLbl.text = "Enter Message"
        placeHolderLbl.font = UIFont.systemFont(ofSize: 16)
        placeHolderLbl.textColor = .lightGray
        return placeHolderLbl
    }()
    
    // Mark: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Mark: Autoresizing
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageInputView)
        messageInputView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 10, paddingLeft: 4, paddingBottom: 8, paddingRight: 8)
        
        addSubview(placeHolder)
        placeHolder.anchor(left: messageInputView.leftAnchor, paddingLeft: 4)
        placeHolder.centerY(inView: messageInputView)
        
        NotificationCenter.default.addObserver(self, selector:#selector(handleTextInputChange), name:UITextView.textDidChangeNotification, object:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    //Mark:
    
    @objc func handleSendMesssage(){
        print("DEBUG: Handle send message here....")
        guard let text = messageInputView.text else {return}
        delegate?.inputView(self, wantsToSend: text)
    }
    
    
    @objc func handleTextInputChange(){
        print("DEBUG: Handle TEXT INPUT message here....")
        placeHolder.isHidden = !messageInputView.text.isEmpty
    }
    // MARK: Helper
    
    func clearMessageText(){
        messageInputView.text = nil
        placeHolder.isHidden = false
    }
    
}
