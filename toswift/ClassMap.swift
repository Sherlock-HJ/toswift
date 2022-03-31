//
//  ClassMap.swift
//  toswift
//
//  Created by wuhongjia on 2022/3/8.
//

import Foundation

struct ClassMap {
    static let map = [
        "int64_t": "Int",
        "int32_t": "Int",
        "int": "Int",
        "NSInteger": "Int",
        "double": "Double",
        "float": "Float"
    ]
}

fileprivate extension ClassMap {
    func test() {
        
    }
}
