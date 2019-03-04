//
//  StringError.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/3/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Foundation

extension String: Error { }

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
