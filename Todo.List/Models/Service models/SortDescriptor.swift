//
//  SortDescriptor.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/3/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Foundation

struct Sort {
    let by: Todo.CodingKeys
    let type: SortType
    enum SortType: String {
        case ascending = "asc"
        case descending = "desc"
    }
}
