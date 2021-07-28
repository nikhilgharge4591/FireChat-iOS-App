//
//  ProfileViewModel.swift
//  FireChat
//
//  Created by Nikhil Gharge on 16/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit

enum ProfileViewModel: Int, CaseIterable{
    
    case accountInfo = 0
    case settings = 1
    
    var description: String {
        switch self {
        case .accountInfo:
            return "Account Info"
        case .settings:
            return "Settings"
        }
    }
    
    var iconImageName: String{
        switch self {
        case .accountInfo:
            return "person.circle"
        case .settings:
            return "gear"
        }
    }
}
