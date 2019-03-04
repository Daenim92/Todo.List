//
//  NotificationService.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

let notificationServiceMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            switch action {
            case EditActions.saved(let todo, _):
                switch todo.notificationBefore{
                case .none:
                    dependency.appStateStore.dispatch(NotificationActions.remove(todo))
                case .some:
                    dependency.appStateStore.dispatch(NotificationActions.add(todo))
                }
            default: break
            }
            next(action)
        }
    }
}
