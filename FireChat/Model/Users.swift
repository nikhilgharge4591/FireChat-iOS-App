//
//  Users.swift
//  FireChat
//
//  Created by Nikhil Gharge on 04/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation

struct Users {
    let uid: String
    let profileImageUrl:String
    let username: String
    let fullname:String
    let email:String
    
    init(dictionary:[String:Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["ProfileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
