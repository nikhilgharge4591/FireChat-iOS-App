//
//  ProfileFooter.swift
//  FireChat
//
//  Created by Nikhil Gharge on 16/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit

protocol ProfileFooterDelegate: class {
    func handleLogout()
}

class ProfileFooter: UIView {
    
    //Mark: - Properties
    
    weak var delegate: ProfileFooterDelegate?
    
    
    private lazy var logoutButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action:#selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    //Mark: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        logoutButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        logoutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - Helpers
    
    @objc func handleLogout(){
        delegate?.handleLogout()
    }
}
