//
//  StatementProtocol.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/7.
//

import Foundation

struct StatementProtocol: Features, Fragment {
    static var regular: String {
        #"@protocol +\w+ *<\w+>"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let oc = ocFragment
        let arr = oc.match(string: #"\w+"#)
        return "@objc protocol \(arr[1]): NSObjectProtocol {"
    }
    
}
