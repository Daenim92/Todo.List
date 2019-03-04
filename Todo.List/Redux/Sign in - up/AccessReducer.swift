//
//  NetworkReducer.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

func accessReducer(action: Action, state: AccessState?) -> AccessState {
    var state = state ?? AccessState()
    
    switch action {
    case let uAction as UserAccessActions:
        switch uAction {
        case .switchButtonType(let type):
            state.buttonSignUpType = type
            
        case .typedUser(let s):
            state.typedUser = s
            
        case .typedPassword(let s):
            state.typedPassword = s
        }
        
    case let iAction as InternalAccessAction:
        switch iAction {
            
        case .setAccess(let access):
            state.accessType = access
            state.error = nil
        case .gotError(let error):
            state.accessType = .none
            state.error = error
        }
        
    default:
        break
    }
  
    return state
}
