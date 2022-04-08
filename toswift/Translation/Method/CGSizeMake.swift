//
//  CGSizeMake.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/6.
//

import Foundation
/**
 CGSize(width: 9, height: 9)
 */

struct CGSizeMakeCall: Features, Fragment {
    static var regular: String {
        #"CGSizeMake *\(.+, *"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        var oc  = ocFragment.replacingOccurrences(of: " ", with: "")
        
        oc = oc.replacingOccurrences(of: "CGSizeMake(", with: "CGSize(width: ")
        
        oc = oc.replacingOccurrences(of: ",", with: ", height: ")
        
        return oc
    }
    
}
