//
//  APIError.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/3/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Foundation

struct APIError: Decodable {
    let message: String
    let fields: [String: [String]]?
}

extension APIError {
    func details() -> String { return fields?.values.map { $0.joined(separator: "\n") }.joined(separator: "\n" ) ?? message }
}

extension APIError: Error, LocalizedError {
    var errorDescription: String? { return details() }
}
