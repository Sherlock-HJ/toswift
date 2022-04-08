//
//  AddSubviewMethod.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/6.
//

import Foundation

struct AddSubviewMethodCall: Features, Fragment {
    static var regular: String {
        #"\[.+ +addSubview\:.+\]"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let arr = ocFragment.components(separatedBy: "addSubview:")
        
        guard arr.count == 2 else { return ocFragment }
        let superView = arr[0].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: " ", with: "")
        let subView = arr[1].replacingOccurrences(of: "]", with: "").replacingOccurrences(of: " ", with: "")
        return "\(superView).addSubview(\(subView))"
    }

    
}
