//
//  TodoListState.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

struct TodoListState {
    var todos: [Int: Page] = [:]
    var isLoading: Bool = false
    var sort: Sort = Sort(by: .dueBy, type: .ascending)
}
