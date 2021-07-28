//
//  MessageCell.swift
//  FireChat
//
//  Created by Nikhil Gharge on 08/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UICollectionViewCell {
    
    //Mark: Properties
    
    var message: UserMessages? {
        didSet {configureUI()}
    }
    
    var bubbleRightAnchor: NSLayoutConstraint!
    var bubbleLeftAnchor: NSLayoutConstraint!
    
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.lightGray
        return profileImageView
    }()
    
    
    private let messageTextView: UITextView = {
        let messageTextView = UITextView()
        messageTextView.backgroundColor = .clear
        messageTextView.font = .systemFont(ofSize: 16)
        messageTextView.isScrollEnabled = false
        messageTextView.isEditable = true
        messageTextView.text = "Some test message for now..."
        return messageTextView
    }()
    
    private let bubbleContainer: UIView = {
        let bubbleContainer = UIView()
        bubbleContainer.backgroundColor = .systemPurple
        return bubbleContainer
    }()
    
    //Mark: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4)
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top:topAnchor, bottom: bottomAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false

        bubbleContainer.addSubview(messageTextView)
        messageTextView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        guard let message = message else {
            return
        }
        let viewModel = MessageViewModel(message: message)
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        messageTextView.textColor = viewModel.messageTextColor
        messageTextView.text = message.text
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        print("DEBUG: Left Anchor \(bubbleLeftAnchor.isActive)")
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        print("DEBUG: Right Anchor \(bubbleRightAnchor.isActive)")
        
        profileImageView.isHidden = viewModel.shouldProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
