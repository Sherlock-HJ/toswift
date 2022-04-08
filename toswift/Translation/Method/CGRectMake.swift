//
//  CGRectMake.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/6.
//

import Foundation
/**
 CGRect(x: 0, y: 0, width: 29, height: 19)
 */
struct CGRectMakeCall: Features, Fragment {
    static var regular: String {
        #"CGRectMake *\(.+, *"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        var oc  = ocFragment.replacingOccurrences(of: " ", with: "")
        
        oc = oc.replacingOccurrences(of: "CGRectMake(", with: "CGRect(x: ")
        
        let arr = oc.components(separatedBy: ",")
        
        guard arr.count == 4 else { return ocFragment }
        
        return "\(arr[0]), y: \(arr[1]), width: \(arr[2]), height: "
    }
    
}
