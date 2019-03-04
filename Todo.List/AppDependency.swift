//
//  AppDependancy.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Dip
import ReSwift
import ReSwiftRouter
import Alamofire

enum DependencyTag: String, DependencyTagConvertible {
    case apiUrl
}

let dependency: DependencyContainer = DependencyContainer(autoInjectProperties: true) {
    
    //constants
    $0.register(tag: DependencyTag.apiUrl) { "http://testapi.doitserver.in.ua/api" }
    
    //core app components
    $0.register(.singleton) { [loggerMiddleware, notificationServiceMiddleware] }
    $0.register(.singleton) { Store<AppState>(reducer: appReducer, state: nil, middleware: $0) }
    $0.register(.eagerSingleton) {
        Router<AppState>(store: $0,
                         rootRoutable: WindowRoutable(),
                         stateTransform: { $0.select { $0.navigationState } })
    }
    
    // api dependencies
    $0.register(.singleton) { API(session: $0) }
    $0.register(.singleton) { () -> SessionManager in 
        let s = SessionManager.default
        s.adapter = APIAuthAdapter()
        return s
    }
    
    //additional components
    $0.register(.singleton) { () -> JSONDecoder in
        let d = JSONDecoder()
        d.dateDecodingStrategy = .secondsSince1970
        return d
    }
    $0.register(.singleton) { () -> JSONEncoder in
        let d = JSONEncoder()
        d.dateEncodingStrategy = .custom { (date: Date, encoder: Encoder) throws in
            let roundedTimeInterval = date.timeIntervalSince1970 .rounded(.down)
            var c = encoder.singleValueContainer()
            try c.encode(roundedTimeInterval)
        }
        return d
    }
    $0.register { (time: DateFormatter.Style, date: DateFormatter.Style) -> DateFormatter in
        let f = DateFormatter()
        f.timeStyle = time
        f.dateStyle = date
        return f
    }
}

//convenience
extension DependencyContainer {
    var appStateStore: Store<AppState> { return try! resolve() }
    var router: Router<AppState> { return try! resolve() }
    
    var apiUrl: String { return try! resolve(tag: DependencyTag.apiUrl) }
    var apiSession: API { return try! resolve() }
    var apiDecoder: JSONDecoder { return try! resolve() }
    var apiEncoder: JSONEncoder { return try! resolve() }

    func formatter(time: DateFormatter.Style, date: DateFormatter.Style) -> DateFormatter
    { return try! resolve(arguments: time, date)  }
}
