//
//  UIEdgeInsetsMake.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/11.
//

import Foundation
/**
 UIEdgeInsets(top: 15, left: 17, bottom: 20, right: 17)
 */
struct UIEdgeInsetsMakeCall: Features, Fragment {
    static var regular: String {
        #"UIEdgeInsetsMake *\(.+, *"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        var oc  = ocFragment.replacingOccurrences(of: " ", with: "")
        
        oc = oc.replacingOccurrences(of: "UIEdgeInsetsMake(", with: "UIEdgeInsets(top: ")
        
        let arr = oc.components(separatedBy: ",")
        
        guard arr.count == 4 else { return ocFragment }
        
        return "\(arr[0]), left: \(arr[1]), bottom: \(arr[2]), right: "
    }
    
}
