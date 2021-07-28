//
//  MessageViewModel.swift
//  FireChat
//
//  Created by Nikhil Gharge on 09/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit

struct MessageViewModel {
    
    private let message: UserMessages
    
    var messageBackgroundColor: UIColor {
        return message.isCurrentUser ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : .systemPink
    }
    
    var messageTextColor: UIColor {
        return message.isCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool{
        return message.isCurrentUser
    }
    
    var leftAnchorActive:Bool{
        return !message.isCurrentUser
    }
    
    var shouldProfileImage: Bool{
        return message.isCurrentUser
    }
    
    var profileImageUrl: URL?{
        guard let user = message.user else {
            return nil
        }
        return URL(string: user.profileImageUrl)
    }
    
    init(message:UserMessages) {
        self.message = message
    }
}
