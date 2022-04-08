//
//  StatementClass.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/7.
//

import Foundation

struct StatementClass: Features, Fragment {
    static var regular: String {
        #"@class +\w+"#
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
