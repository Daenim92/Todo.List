//
//  TodoListActions.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift
import ReSwiftRouter
import Alamofire
import CodableAlamofire

enum TodoListActions: Action {
    case setData([Int: Page])
    case addData(Page)
    case sort(Sort)
    case startLoading
}


extension TodoListActions {
    static func getTodos(_ apiSession: API = dependency.apiSession, _ decoder: JSONDecoder = dependency.apiDecoder, page: Int)
        -> Store<AppState>.ActionCreator
    {
        return { state, store in
            apiSession.getTodos(sort: state.todoListState.sort, page: page)
                .responseDecodableObject(decoder: decoder) { (response: DataResponse<Page>) in
                    switch response.result {
                    case .success(let value):
                        store.dispatch(TodoListActions.addData(value))
                    case .failure:
                        store.dispatch(TodoListActions.setData([:]))
                    }
            }
            
            return TodoListActions.startLoading
        }
    }
    
    static func getNextPage() -> Store<AppState>.ActionCreator {
        return { state, store in
            if state.todoListState.isLoading == true { return nil }
            
            let nextPage = (state.todoListState.todos.keys.sorted { $0 < $1 }.last ?? 0) + 1
            store.dispatch(getTodos(page: nextPage))
            
            return TodoListActions.startLoading
        }
    }
}
