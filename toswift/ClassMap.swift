//
//  ClassMap.swift
//  toswift
//
//  Created by wuhongjia on 2022/3/8.
//

import Foundation

struct ClassMap {
    static let map = [
        "int64_t": "Int64",
        "int32_t": "Int32",
        "int": "Int",
        "NSInteger": "Int",
        "double": "Double",
        "float": "Float",
        "NSString": "String",
        "void": "Void",
        "BOOL": "Bool",
        "YES": "true",
        "NO": "false",

        "NSTimeInterval" : "TimeInterval"
    ]
}

fileprivate extension ClassMap {
    func test() {
    }
}
