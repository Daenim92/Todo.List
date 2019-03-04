//
//  NotificationReducer.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

func notificationReducer(action: Action, state: NotificationState?) -> NotificationState {
    var state = state ?? NotificationState()
    
    switch action {
    case let n as NotificationActions:
        switch n {
        case .setPending(let all):
            state.reminders = all
        case .gotError(let error):
            state.error = error
        }
    default:
        break
    }
    
    return state
}
