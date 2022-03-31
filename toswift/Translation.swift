//
//  Translation.swift
//  toswift
//
//  Created by wuhongjia on 2022/3/7.
//

import Foundation

func translationMain() {
    
    // 1. 过滤命令行传入的文件名
    if CommandLine.arguments.count < 3 {
        print("缺少文件路径片段 eg: MZFeedback")
        return
    }
    
    let filePath = CommandLine.arguments[2]
    
    let directoryPath = CurrentDirectoryPath

    let manager = FileManager.default

    // 获取资源目录下所有文件
    let resourcePaths = manager.enumerator(atPath: directoryPath)

    print("查找文件中...")
    
    var filePaths = [String]()
    while let path = (resourcePaths?.nextObject() as? String) {
        
        // 2. 查找
        if path.suffix(2) == ".h",
           path.contains(filePath) {
            filePaths.append(path)
        }
    }
    
    print("查找结束")

    if filePaths.count == 0 {
        print("未找到")
        return
    }
    
    if filePaths.count > 1 {
        print("此文件路径片段包含1个以上文件")
        print(filePaths)
        return
    }
    
    let path = filePaths[0]
    let hPath = directoryPath.appendingFormat("/%@", path)
    let mPath = directoryPath.appendingFormat("/%@.m", String(path.prefix(path.count - 2)))
    
    var clsName = ""
    hPath.contentString?.match(string: #"@interface +\w+ *: *"#).forEach({ string in
        string.match(string: #" \w+"#).forEach { name in
            clsName = name.replacingOccurrences(of: " ", with: "")
        }
    })
    
    if clsName.isEmpty {
        print("此文件路径.h中无class")
        print(filePaths)
        return
    }

    var cls = TranslationSwiftClass(clsName: clsName)
    
    
//    获取.h 的属性
    let hContent = hPath.contentString
    hContent?.match(string: #"@property.+;"#).forEach({ property in
        //储存属性
        cls.propertyList.append(get(property: property, isPrivate: false))
    })
    
    //    获取.h 的方法
    hContent?.match(string: #"[\+-] *\( *\w+ *\*?\).+\;"#).forEach({ method in
        //储存方法
        cls.methodList.append(get(method: method, isPrivate: false))
    })
    
    //    获取.m 的属性
    let mContent = mPath.contentString
    mContent?.match(string: #"@property.+;"#).forEach({ property in
        //储存属性
        let p = get(property: property, isPrivate: true)
        if cls.propertyList.filter({ $0.name == p.name }).isEmpty {
            cls.propertyList.append(p)
        }
    })
    
    //    获取.m 的方法
    mContent?.match(string: #"[\+-] *\( *\w+ *\*?\).+\{"#).forEach({ method in
        //储存方法
        let m = get(method: method, isPrivate: true)
        if cls.methodList.filter({ $0.name == m.name }).isEmpty {
            cls.methodList.append(m)
        }
    })
    cls.methodList.forEach { m in
        print(m.name)
    }
    
    // 获取继承/遵守列表
    
    hContent?.match(string: #"@interface[\w :]+(\s*<\s*\w+ *,*\s*\w+\s*>)?"#).forEach({ property in
        if let dad = property.match(string: #": *\w+"#).first {
            
            cls.inheritList.append(dad.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ":", with: ""))
        }

        if let pro = property.match(string: #"<\s*\w+ *,*\s*\w+\s*>"#).first {
            let arr = pro.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
                .components(separatedBy: ",")
            cls.inheritList.append(contentsOf: arr)
        }
    })
    
    mContent?.match(string: #"@interface[\w \(\)]+(\s*<\s*\w+ *,*\s*\w+\s*>)?"#).forEach({ property in
        if let pro = property.match(string: #"<\s*\w+ *,*\s*\w+\s*>"#).first {
            let arr = pro.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "<", with: "")
                .replacingOccurrences(of: ">", with: "")
                .components(separatedBy: ",")
            cls.inheritList.append(contentsOf: arr)
        }
    })
    
    
    print(path)
    writeFile(path: path, cls: cls)
}

fileprivate func writeFile(path: String, cls: TranslationSwiftClass) {
    let fullPath = "\(CurrentDirectoryPath)/\(path.prefix(path.count - 1))swift"
    print(fullPath)
    if FileManager.default.fileExists(atPath: fullPath) {
        print("文件已存在是否继续？请输入y/n确认")
        let str = String(data: FileHandle.standardInput.availableData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        if str != "y" {
            return
        }
    }
    print(FileManager.default.createFile(atPath: fullPath, contents: cls.toString().data(using: .utf8)))
}

fileprivate func get(property: String, isPrivate: Bool) -> TranslationSwiftClass.Property {
    //    获取 属性的 name
    var nameStr = ""
    property.match(string: #"\w+;"#).forEach { name in
        nameStr = name.replacingOccurrences(of: ";", with: "")
    }
    
    //    获取 属性的 type
    var typeStr = ""
    property.match(string: #" +\w+ +"#).forEach { type in
        typeStr = type.replacingOccurrences(of: " ", with: "")
    }
    
    return TranslationSwiftClass.Property(name: nameStr, type: typeStr, readonly: property.contains("readonly"), isPrivate: isPrivate)
}


fileprivate func get(method: String, isPrivate: Bool) -> TranslationSwiftClass.Method {
    let adorn: TranslationSwiftClass.Method.Adorn = method.replacingOccurrences(of: " ", with: "").hasPrefix("+") ? .istatic : .iobjc

    if method.contains(":") {
        
        // 获取方法参数
        var parameter = [TranslationSwiftClass.Property]()
        method.match(string: #": *\(\w+ *\**\) *\w+"#).forEach { paramStr in
            let parameterGroup =  paramStr.match(string: #"\w+"#)
            if parameterGroup.count == 2 {
                parameter.append(TranslationSwiftClass.Property(name: parameterGroup[1], type: parameterGroup[0], readonly: true, isPrivate: true))
            }
        }
        
        // 获取方法名
        let name = method.match(string: #"\w+:"#).joined(separator: "")
        
        //储存方法
        return TranslationSwiftClass.Method(name: name, parameter: parameter, adorn: adorn, isPrivate: isPrivate)
    }
    
    // 获取方法名
    let name = method.match(string: #"\w+"#)[1]

    //储存方法
    return TranslationSwiftClass.Method(name: name, parameter: [], adorn: adorn, isPrivate: isPrivate)
}


extension TranslationSwiftClass {
    
    func toString() -> String {
        
        let methodStr = methodList.map({ method in
            
            let methodParamStr = method.parameter.map({ p in
                "\(p.name): \(p.type)"
            }).joined(separator: ", ")
            
            return "@objc(\(method.name))\n\(method.isPrivate ? "private " : "")\(method.adorn == .istatic ? "static " : "")func \(method.name.components(separatedBy: ":")[0])(\(methodParamStr)) {}"
            
        }).joined(separator: "\n\n")
        
        
        
        return """
        
        class \(clsName): \(inheritList.joined(separator: ", ")) {
                     \(propertyList.map({ property in
                         "\(property.isPrivate ? "private " : "")var \(property.name): \(property.type)"
                }).joined(separator: "\n\n"))
        
        \(methodStr)
        }
        
        """
    }
    
}
