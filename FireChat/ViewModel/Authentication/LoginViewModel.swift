//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Nikhil Gharge on 21/08/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation

struct LoginViewModel {
    var email:String?
    var password:String?
    
    func formIsValid() -> Bool{
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
