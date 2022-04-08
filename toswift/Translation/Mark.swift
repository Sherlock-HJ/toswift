//
//  Mark.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/2.
//

import Foundation

struct Mark: Features, Fragment {
    static var regular: String {
        #"#pragma *mark *- *[\w ]+"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let oc = ocFragment
        guard var title = oc.match(string: #"- *[\w ]+"#).first?.replacingOccurrences(of: " ", with: "") else {
            return ""
        }
        title.remove(at: title.startIndex)
        return "// MARK: - \(title)"
    }
    
}
