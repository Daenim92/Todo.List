//
//  TodoListActions.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift
import ReSwiftRouter

enum DetailsAction: Action {
    case examine(Todo?)
}

extension DetailsAction {
    static func delete(apiSession: API = dependency.apiSession, todo: Todo) -> Store<AppState>.ActionCreator {
        return { state, store in
            if let id = state.detailsState.examinedTodo?.id {
                apiSession.delete(id)
                    .response() {
                        switch $0.error {
                        case .none:
                            break
                        case .some(_):
                            break
                        }
                        store.dispatch(DetailsAction.examine(nil))
                }
            }
            
            return nil
        }
    }
}
