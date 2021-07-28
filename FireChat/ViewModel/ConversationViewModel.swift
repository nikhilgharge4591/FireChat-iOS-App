//
//  ConversationViewModel.swift
//  FireChat
//
//  Created by Nikhil Gharge on 15/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation

import UIKit

struct ConversationViewModel {
    
    
    let conversation: ConversationMessage
    
    var profileImageUrl: URL?{
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestamp: String{
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        return dateFormatter.string(from: date)
    }

    
    init(conversation: ConversationMessage) {
        self.conversation = conversation
    }
}
