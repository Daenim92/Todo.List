//
//  EditActions.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

enum EditActions: Action {
    case edit(Todo)
    
    case editTitle(String)
    case editDue(Date)
    case editDescription(String)
    case editPriority(Todo.Priority)
    case editReminder(TimeInterval?)
    
    case saved(Todo, with: Error?)
}

extension EditActions {
    static func save(apiSession: API = dependency.apiSession, todo: Todo) -> Store<AppState>.ActionCreator {
        return { state, store in
            apiSession.saveTodo(todo)
                .response() {
                    store.dispatch(EditActions.saved(todo, with: $0.error))
                }
            
            return nil
        }
    }
}
