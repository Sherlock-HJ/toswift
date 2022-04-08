//
//  NS_ASSUME_NONNULL.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/2.
//

import Foundation

struct NS_ASSUME_NONNULL: Features, Fragment {
    static var regular: String {
        #"NS_ASSUME_NONNULL\w+"#
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
