//
//  Todo.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/1/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Foundation

struct Todo: Codable {
    let id: Int?
    var title: String
    var dueBy: Date
    var priority: Priority
    
    enum Priority: String, Codable {
        case high = "High"
        case normal = "Normal"
        case low = "Low"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case dueBy
        case priority
    }
    
    //internal use
    
    var notificationBefore: TimeInterval?
    
    init(id: Int? = nil, title: String, dueBy: Date, priority: Priority) {
        self.id = id
        self.title = title
        self.dueBy = dueBy
        self.priority = priority
    }
}

extension Todo.Priority: CustomStringConvertible {
    var description: String {
        switch self {
        case .high:
            return "↑ High"
        case .normal:
            return "⇡ Normal"
        case .low:
            return "↓ Low"
        }
    }
}
