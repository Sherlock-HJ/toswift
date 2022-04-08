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


extension Range where Bound == String.Index {
    init(string: String, nsrange: NSRange) {
        let start = string.index(string.startIndex, offsetBy: nsrange.location)
        let end = string.index(string.startIndex, offsetBy: nsrange.location + nsrange.length)
        self.init(uncheckedBounds: (lower: start, upper: end))
    }
}


extension NSRange {
    
    func range(string: String) -> Range<String.Index> {
        Range(string: string, nsrange: self)
    }
}

extension String {
    
    func index(_ idx: Int) -> String.Index {
        self.index(self.startIndex, offsetBy: idx)
    }
    
    func range(nsrange: NSRange) -> Range<String.Index> {
        Range(string: self, nsrange: nsrange)
    }
    
    func rangeString(nsrange: NSRange) -> String {
        String(self[self.range(nsrange: nsrange)])
    }
    
    func matchRange(string: String) -> [NSRange] {
        let regular = try? NSRegularExpression(pattern: string, options: .anchorsMatchLines)
        guard let regular = regular else { return [] }

        return regular.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count)).map({ $0.range })
    }
    
    func match(string: String) -> [String] {
        var arr = [String]()
        let regular = try? NSRegularExpression(pattern: string, options: .anchorsMatchLines)
        guard let regular = regular else { return [] }

        let res = regular.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count))

        for item in res {
            arr.append(self.rangeString(nsrange: item.range))
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
