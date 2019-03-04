//
//  AppState.swift
//  Todo.List
//
//  Created by Dmytro Baida on 2/26/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift
import ReSwiftRouter

struct AppState : StateType {
    var accessState: AccessState
    var todoListState: TodoListState
    var detailsState: DetailsState
    var editState: EditState
    var notificationState: NotificationState
    
    var navigationState: NavigationState
}
