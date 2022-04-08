//
//  EqualSignLeft.swift
//  toswift
//
//  Created by wuhongjia on 2022/3/31.
//

import Foundation

/// 等号左侧的声明 eg: `NSString * str = `
struct EqualSignLeftStatement: Features, Fragment {
    static var regular: String {
        #"\n\w+[ \*]+\w+ *="#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let oc = ocFragment
        let arr = oc.match(string: #"\w+"#)

        return "var \(arr[1]): \(arr[0]) ="
    }
    
}
