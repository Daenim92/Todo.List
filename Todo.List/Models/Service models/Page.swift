//
//  Page.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/3/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Foundation

struct Page: Decodable {
    let tasks: [Todo]
    let meta: Meta
    struct Meta: Decodable {
        let current: Int
        let limit: Int
        let count: Int
    }
}
