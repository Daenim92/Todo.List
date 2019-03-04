//
//  Logger.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/2/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import ReSwift

let loggerMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            print(">  \(action)")
            next(action)
        }
    }
}
