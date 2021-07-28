//
//  UserMessages.swift
//  FireChat
//
//  Created by Nikhil Gharge on 08/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Firebase

struct UserMessages {
    let text:String
    let toId:String
    let fromId:String
    var timestamp:Timestamp!
    var user:Users?
    
    var isCurrentUser:Bool
    
    var chatUser: String{
        return isCurrentUser ? toId : fromId
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp  ?? Timestamp(date: Date())
        
        self.isCurrentUser = fromId == Auth.auth().currentUser?.uid
        print("DEBUG IS THAT CURRENT USER \(isCurrentUser)")
    }
    
    
}

struct ConversationMessage{
    let user: Users
    let message: UserMessages
}
