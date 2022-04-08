//
//  Interface.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/1.
//

import Foundation

struct Interface: Features, Fragment {
    static var regular: String {
        #"@interface[\w :\(\)]+(\s*<\s*\w+ *(,*\s*\w+\s*)*>)?"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange
    
    var swiftFragment: String {
        let oc = ocFragment.replacingOccurrences(of: "@interface", with: "@objcMembers class")
        
        var swift = ""
        
        if oc.contains(":") {
            let arr = oc.components(separatedBy: ":")
            if arr.count == 2 {
                swift = "\(arr[0].trimmingCharacters(in: .whitespacesAndNewlines)): \(arr[1].trimmingCharacters(in: .whitespacesAndNewlines))"
            }
        } else {
            let arr = oc.components(separatedBy: "()")
            if arr.count > 0 {
                swift = "\(arr[0].trimmingCharacters(in: .whitespacesAndNewlines)): "
            }
        }
        
        if let pro = oc.match(string: #"\s*<\s*\w+ *(,*\s*\w+\s*)*>"#).first {
            let protocolList = pro.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
                .components(separatedBy: ",")
            if oc.contains(":") {
                swift += ", " + protocolList.joined(separator: ", ")
            } else {
                swift += protocolList.joined(separator: ", ")
            }
        }
        
        swift += " {"
        
        return swift
    }
    
}
