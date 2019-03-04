//
//  Todo.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/3/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Alamofire

extension API {
    
    func getTodos(sort: Sort = Sort(by: .dueBy, type: .descending), page: Int) -> DataRequest {
        let params: Parameters = [
            "sort" : "\(sort.by.rawValue) \(sort.type.rawValue)",
            "page" : page
        ]
        return self.session
            .request(dependency.apiUrl + "/tasks", method: .get, parameters: params, encoding: URLEncoding.default)
            .defaultValidate()
    }
    
    func saveTodo(_ todo: Todo) -> DataRequest {
        let params: Parameters = todo.asParameters(encoder: dependency.apiEncoder)
        
        switch todo.id {
        case .none:
            return self.session
                .request(dependency.apiUrl + "/tasks", method: .post, parameters: params, encoding: JSONEncoding.default)
                .defaultValidate()
        case .some(let id):
            return self.session
                .request(dependency.apiUrl + "/tasks/\(id)", method: .put, parameters: params, encoding: JSONEncoding.default)
                .defaultValidate()
        }
    }
    
    func delete(_ id: Int) -> DataRequest {
        return self.session.request(dependency.apiUrl + "/tasks/\(id)", method: .delete)
                .defaultValidate()
    }
}
