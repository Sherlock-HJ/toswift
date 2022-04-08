//
//  Semicolon.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/2.
//

import Foundation

/// 分号
struct Semicolon: Features, Fragment {
    static var regular: String {
        #"\;"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        return ""
    }
    
}
