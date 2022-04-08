//
//  Import.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/2.
//

import Foundation

struct Import: Features, Fragment {
    static var regular: String {
        #"#import +["<]{1}[\w.+/]+[">]{1}"#
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
