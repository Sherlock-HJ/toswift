//
//  Implementation.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/1.
//

import Foundation

struct Implementation: Features, Fragment {
    static var regular: String {
        #"@implementation +\w+"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        return ocFragment.replacingOccurrences(of: "@implementation", with: "class") + " {"
    }
    
}
