//
//  Sign Up.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/2/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Alamofire

extension API {
    func signUp(user: String, password: String) -> DataRequest {
        let params: Parameters = [
            "email" : user,
            "password" : password
        ]
        return self.session
            .request(dependency.apiUrl + "/users", method: .post, parameters: params, encoding: JSONEncoding.default)
            .defaultValidate()
    }
    
    func signIn(user: String, password: String) -> DataRequest {
        let params: Parameters = [
            "email" : user,
            "password" : password
        ]
        return self.session
            .request(dependency.apiUrl + "/auth", method: .post, parameters: params, encoding: JSONEncoding.default)
            .defaultValidate()
    }
}
