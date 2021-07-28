//
//  ConversationCell.swift
//  FireChat
//
//  Created by Nikhil Gharge on 15/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell{
    
    
    // Mark:- Properties
    var conversation: ConversationMessage?{
        didSet { configureUI()}
    }
    
     let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.lightGray
        return profileImageView
    }()
    
     let usernameLabel: UILabel = {
        
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return userNameLabel
    }()
    
     let messageTextLabel: UILabel = {
        
        let fullUserNameLabel = UILabel()
        fullUserNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        fullUserNameLabel.textColor = .lightGray
        return fullUserNameLabel
    }()
    
     let timestamp: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize:12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    //Mark:- Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(timestamp)
        timestamp.anchor(top:topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark:- Helpers
    func configureUI() {
        guard let conversation = conversation else {return}
        let viewModel = ConversationViewModel(conversation: conversation)
        
        timestamp.text = viewModel.timestamp
        usernameLabel.text = conversation.user.username
        messageTextLabel.text = conversation.message.text
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
