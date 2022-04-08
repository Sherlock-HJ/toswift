//
//  ButtonWithType.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/6.
//

import Foundation

/// buttonWithType
struct ButtonWithTypeCall: Features, Fragment {
    static var regular: String {
        #"\[ *\w+ +buttonWithType: *\w+ *\]"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let arr = ocFragment.components(separatedBy: "buttonWithType:")
        guard arr.count == 2 else {
            return ocFragment
        }
    
        let cls = arr[0].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "[", with: "")
        var type = arr[1].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "UIButtonType", with: "")
        
        type = String(type.prefix(1)).lowercased() + type[type.index(1)..<type.index(type.count)]
        return "\(cls)(type: .\(type))"
    }
    
}
