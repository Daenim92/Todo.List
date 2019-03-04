//
//  AppReducer.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift
import ReSwiftRouter

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(accessState: accessReducer(action: action, state: state?.accessState),
                    todoListState: todoListReducer(action: action, state: state?.todoListState),
                    detailsState: detailsReducer(action: action, state: state?.detailsState),
                    editState: editReducer(action: action, state: state?.editState),
                    notificationState: notificationReducer(action: action, state: state?.notificationState),
                    
                    navigationState: NavigationReducer.handleAction(action, state: state?.navigationState))
}
