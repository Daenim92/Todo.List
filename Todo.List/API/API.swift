//
//  API.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/2/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Alamofire

struct API {
    let session: SessionManager
}

extension API {
    static let apiErrorValidation = { (request: URLRequest?, response: HTTPURLResponse, data: Data?) -> Request.ValidationResult in
        if let data = data, let error = try? dependency.apiDecoder.decode(APIError.self, from: data) {
            return .failure(error)
        } else {
            return .success
        }
    }
}

extension DataRequest {
    @discardableResult
    func defaultValidate() -> Self {
        return validate(API.apiErrorValidation).validate()
    }
}

struct APIAuthAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        switch dependency.appStateStore.state.accessState.accessType {
        case .token(let tString):
            var request = urlRequest
            var headers = request.allHTTPHeaderFields ?? [:]
            headers["Authorization"] = "Bearer: \(tString)"
            request.allHTTPHeaderFields = headers
            return request
        case .none:
            return urlRequest
        }
    }
}
