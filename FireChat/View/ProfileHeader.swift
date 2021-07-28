//
//  ProfileHeader.swift
//  FireChat
//
//  Created by Nikhil Gharge on 16/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileHeaderDelegate: class {
    func dismissController()
}

class ProfileHeader: UIView{
    
    //Mark: - Properties
    
    var user: Users? {
        didSet {populateUserData()}
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Eddie Rock"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@venom"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    
    
    //Mark: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradientLayer()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark:  - Helpers
    
    func configureUI(){
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top:profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width:48)
        
    }
    
    func configureGradientLayer(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0,1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    func populateUserData(){
        guard let user = user else {
            return
        }
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
    }
    
    @objc func handleDismiss(){
        delegate?.dismissController()
    }
    
}
