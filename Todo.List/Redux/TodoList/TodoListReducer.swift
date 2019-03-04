//
//  TodoListReducer.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

func todoListReducer(action: Action, state: TodoListState?) -> TodoListState {
    var state = state ?? TodoListState()

    switch action {
    case TodoListActions.setData(let data):
        state.todos = data
        state.isLoading = false
        
    case TodoListActions.addData(let page):
        state.todos[page.meta.current] = page
        state.isLoading = false
        
    case TodoListActions.startLoading:
        state.isLoading = true
        
    case TodoListActions.sort(let sort):
        state.sort = sort
        
    default:
        break
    }
    return state
}
