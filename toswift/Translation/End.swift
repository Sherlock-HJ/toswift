//
//  End.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/1.
//

import Foundation

struct End: Features, Fragment {
    static var regular: String {
        #"@end"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        return "}"
    }
    
}
