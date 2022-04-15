//
//  Mark.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/2.
//

import Foundation

struct Mark: Features, Fragment {
    static var regular: String {
        #"#pragma *mark *-? *.+"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let oc = ocFragment
        guard let first = oc.match(string: #"#pragma *mark *-? *"#).first else {
            return ocFragment
        }
        let title = oc.replacingOccurrences(of: first, with: "")
        return "// MARK: - \(title)"
    }
    
}
