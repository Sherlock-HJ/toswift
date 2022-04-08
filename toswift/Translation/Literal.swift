//
//  Literal.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/1.
//

import Foundation

/// string 字面量
struct StringLiteral: Features, Fragment {
    static var regular: String {
        #"@""#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        #"""#
    }
    
}

/// Array 字面量
struct ArrayLiteral: Features, Fragment {
    static var regular: String {
        #"@\["#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        #"["#
    }
    
}
