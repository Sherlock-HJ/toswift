//
//  Property.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/1.
//

import Foundation

struct Property: Features, Fragment {
    static var regular: String {
        #"@property[ \(\),\*\w]+"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange
    
    var swiftFragment: String {
        let propertyArr = ocFragment.match(string: #"\w+"#)
        
        guard propertyArr.count >= 2 else {
            return ""
        }
        
        let readonly = ocFragment.match(string: #"\([a-z, ]+\)"#).first?.contains("readonly") == true
        
        let variable = propertyArr.last!
        let type = propertyArr[propertyArr.count - 2]
        
        var str = "var \(variable): \(type)"
        
        if type.hasPrefix("UI") {
            str = "lazy var \(variable) = \(type)()"
        }
        
        if readonly {
            str = "private(set) " + str
        }
        
        return str
    }
    
}
