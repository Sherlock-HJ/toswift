//
//  config.swift
//  toswift
//
//  Created by wuhongjia on 2022/3/7.
//

import Foundation

#if DEBUG
let CurrentDirectoryPath = "/Users/wuhongjia/baidu/muzhi/app-doctor-ios"
#else
let CurrentDirectoryPath = FileManager.default.currentDirectoryPath
#endif

enum Arguments: String {
    case filter
    case translation
}

struct File: CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String {
        description
    }
    
    var description: String {
        """
        importNumber: \(importNumber)
        name: \(name ?? "无")
        path: \(path)
        
        """
    }
    
    var name: String? {
        path.components(separatedBy: "/").last
    }
    var path = ""
    var importNumber = 0
}


extension String {
    
    func match(string: String) -> [String] {
        var arr = [String]()
        let regular = try? NSRegularExpression(pattern: string, options: .anchorsMatchLines)
        guard let regular = regular else { return [] }

        let res = regular.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count))

        for item in res {
            let start = self.index(self.startIndex, offsetBy: item.range.location)
            let end = self.index(self.startIndex, offsetBy: item.range.location + item.range.length - 1)
            
            let str = String(self[start...end])
            arr.append(str)
        }
        return arr
    }
    
    var contentString: String? {
        guard let fileData = FileManager.default.contents(atPath: self),
              let content = String(data: fileData, encoding: .utf8) else { return nil }
        return content
    }
}


struct TranslationSwiftClass {
    struct Property {
        var name: String
        var type: String
        var readonly: Bool
        var isPrivate: Bool
    }
    
    struct Method {
        enum Adorn: String {
            case istatic = "static"
            case iobjc = "objc"
        }
        var name = ""
        var parameter = [Property]()
        var adorn: Adorn
        var isPrivate: Bool
    }
    
    var clsName: String
    var propertyList = [Property]()
    var methodList = [Method]()
    
    /// 继承列表
    var inheritList = [String]()
}
