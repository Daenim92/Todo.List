//
//  EncodableParameters.swift
//  Todo.List
//
//  Created by Dmytro Baida on 3/4/19.
//  Copyright © 2019 Dmytro Baida. All rights reserved.
//

import Alamofire

extension Encodable {
    func asParameters(encoder: JSONEncoder) -> Parameters {
        let data = try! encoder.encode(self)
        let params = try! JSONSerialization.jsonObject(with: data, options: [])
        return params as! Parameters
    }
}
