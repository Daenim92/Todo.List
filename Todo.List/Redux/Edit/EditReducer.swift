//
//  EditReducer.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

func editReducer(action: Action, state: EditState?) -> EditState {
    var state = state ?? EditState()
    
    switch action {
    case let edit as EditActions:
        switch edit {
        case .edit(let todo):
            state.editedTodo = todo
        case .editTitle(let title):
            state.editedTodo?.title = title
        case .editDue(let date):
            state.editedTodo?.dueBy = date
        case .editDescription(_):
            //??
            break
        case .editPriority(let prio):
            state.editedTodo?.priority = prio
        case .editReminder(let reminder):
            state.editedTodo?.notificationBefore = reminder
        case .saved(with: _):
            break
        }
    default:
        break
    }
    
    return state
}
