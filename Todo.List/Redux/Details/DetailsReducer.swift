//
//  TodoListReducer.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

func detailsReducer(action: Action, state: DetailsState?) -> DetailsState {
    var state = state ?? DetailsState()
    
    switch action {
    case DetailsAction.examine(let todo):
        state.examinedTodo = todo
    default:
        break
    }
    
    return state
}
