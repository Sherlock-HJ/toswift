//
//  Method.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/1.
//

import Foundation

struct Method: Features, Fragment {
    static var regular: String {
        #"[\+-] *\( *\w+ *\*?\)[\w \(\):\*]+"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let oc = ocFragment
        var methodStr = ""
        
        // @objc
        var returnValue = ""
        var name = ""
        let isStatic = oc.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("+")
        
        let abcArr = oc.match(string: #"\w+"#)
        
        if oc.contains(":") {
            // 获取方法参数
            var paramArr = [String]()
            oc.match(string: #": *\([ \*\w]+\) *\w+"#).forEach { paramStr in
                let name = paramStr.match(string: #"\) *\w+"#)[0].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ")", with: "")
                var type = paramStr.match(string: #"\([ \*\w]+\)"#)[0]
                let arr =  type.match(string: #"\w+"#).filter({ str in
                    !str.contains("ullable")
                })
                type = arr[0] + (type.contains("ullable") ? "?" : "")

                let p = (name: name, type: type)
                paramArr.append("\(p.name): \(p.type)")
            }
            let methodParamStr = paramArr.joined(separator: ", ")
            
            // 获取方法名
            returnValue = abcArr[0]
            name = oc.match(string: #"\w+:"#).joined(separator: "")
            
            methodStr = "func \(name.components(separatedBy: ":")[0])(\(methodParamStr))"
        } else {
            // 获取方法名
            returnValue = abcArr[0]
            name = abcArr[1]
            
            methodStr = "func \(name)()"
        }
        
        if isStatic {
            methodStr = "static " + methodStr
        }
        
        return "@objc(\(name))\n\(methodStr) -> \(returnValue) "
    }
    
}

/// init
struct InitMethod: Features, Fragment {
    static var regular: String {
        #"- *\(\w+\)init(\w+:\( *\w+[ *]*\)\w+ *)* *\{[^\}\{]+\{[^\}\{]+\}[^\}\{]+\}"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let oc = ocFragment
        
        var methodParamStr = ""
        if oc.contains(":") {
            // 获取方法参数
            var paramArr = [String]()
            oc.match(string: #": *\(\w+ *\**\) *\w+"#).forEach { paramStr in
                let parameterGroup =  paramStr.match(string: #"\w+"#)
                if parameterGroup.count == 2 {
                    
                    let p = (name: parameterGroup[1], type: parameterGroup[0])
                    paramArr.append("\(p.name): \(p.type)")
                }
            }
            
            methodParamStr = paramArr.joined(separator: ", ")
        }
        
        let body = oc.match(string: #"\{[^\}\{]+\}"#).first?.replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return """
        override init(\(methodParamStr)) {
            super.init(\(methodParamStr))
            \(body ?? "")
        }
                       
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        """
    }
}


/// lazy
struct LazyMethod: Features, Fragment {
    static var regular: String {
        #"- *\( *\w+ *\*\)[\w ]+\{\s*if *\([!\w =(nil)]+\) *\{[^\}\{]+\}[^\}\{]+\}"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let oc = ocFragment
        
        let arr = oc.match(string: #"\w+"#)
        
        let body = oc.match(string: #"\{[^\}\{]+\}"#).first?.replacingOccurrences(of: "{", with: "")
            .replacingOccurrences(of: "}", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let returnString = oc.match(string: #"\}[^\}\{]+\}"#).first?
            .replacingOccurrences(of: "}", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return """
        lazy var \(arr[1]): \(arr[0]) = {
            let \(body ?? "")
            \(returnString ?? "")
        }()
        """
    }
}




/// 空参数函数调用
struct EmptyParamMethodCall: Features, Fragment {
    static var regular: String {
        #"\[\w+ +\w+\]"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let arr = ocFragment.match(string: #"\w+"#)
        
        return "\(arr[0]).\(arr[1])()"
    }
    
}

/// 空参数`init`调用
struct EmptyInitMethodCall: Features, Fragment {
    static var regular: String {
        #"\[\[\w+ alloc\] init\]"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        let arr = ocFragment.match(string: #"\w+"#)
        
        return "\(arr[0])()"
    }
    
}

/// 空参数`initWithFrame`调用
struct EmptyInitFrameMethodCall: Features, Fragment {
    static var regular: String {
        #"\[\[\w+ alloc\] initWithFrame:.+\]"#
    }
    
    static var fragmentType: Fragment.Type {
        Self.self
    }
    
    var ocFragment: String
    
    var range: NSRange

    var swiftFragment: String {
        guard let frame = ocFragment.components(separatedBy: ":").last?.replacingOccurrences(of: "]", with: "") else {
            return ocFragment
        }
        
        let arr = ocFragment.match(string: #"\w+"#)
        return "\(arr[0])(frame: \(frame))"
    }
    
}


