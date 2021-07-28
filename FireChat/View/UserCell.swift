//
//  UserCell.swift
//  FireChat
//
//  Created by Nikhil Gharge on 03/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    //Mark: Properties
    
    var user:Users? {
        didSet{ configure()}
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemPurple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        userNameLabel.text = "Spiderman"
        return userNameLabel
    }()
    
    private let fullUserNameLabel: UILabel = {
        
        let fullUserNameLabel = UILabel()
        fullUserNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        fullUserNameLabel.text = "Peter Parker"
        fullUserNameLabel.textColor = .lightGray
        return fullUserNameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 56, width: 56)
        profileImageView.layer.cornerRadius = 56 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullUserNameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft:12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - Helper
    func configure(){
        guard let user = user else { return }
        usernameLabel.text = user.username
        fullUserNameLabel.text = user.fullname
        
        guard let url = URL(string: user.profileImageUrl) else {
            return
        }
        
        profileImageView.sd_setImage(with: url)
    }
    
    
}
