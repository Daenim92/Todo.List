//
//  NetworkState.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

struct AccessState {
    var accessType: AccessType = .none
    enum AccessType {
        case token(String)
        case none
    }
    
    var buttonSignUpType: ButtonType = .signIn
    enum ButtonType {
        case signIn
        case signUp
    }
    
    var typedUser: String?
    var typedPassword: String?
    var error: Error?
}
