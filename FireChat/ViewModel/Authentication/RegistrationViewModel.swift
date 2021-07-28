//
//  RegistrationViewModel.swift
//  FireChat
//
//  Created by Nikhil Gharge on 21/08/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation

struct RegistrationViewModel {
    var email:String?
    var password:String?
    var fullname:String?
    var username:String?
    
    func formIsValid() -> Bool{
        return email?.isEmpty == false  && fullname?.isEmpty == false && username?.isEmpty == false && password?.isEmpty == false
    }
}
