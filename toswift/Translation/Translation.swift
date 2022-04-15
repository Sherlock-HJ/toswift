//
//  Translation.swift
//  toswift
//
//  Created by wuhongjia on 2022/3/7.
//

import Foundation

// MARK: - public
extension Translation {
    mutating func run() -> Translation {
        fragmentList.removeAll()
        for feature in featuresList {
            print(feature.regular)
            content = replace(text: content, for: feature)
        }
        return self
    }
    
    private func replace(text: String, for feature: Features.Type) -> String {
        var string = text
        let result = match(regular: feature.regular, string: string)
        
        // 1.替换代码片段
        result.map({ item in
            feature.fragmentType.init(ocFragment: string.rangeString(nsrange: item.range), range: item.range)
        }).sorted(by: { fragment1, fragment2 in
            // 降序排序
            fragment1.range.location > fragment2.range.location
        }).forEach { fragment in
            // 从文本末尾开始替换
            string.replaceSubrange(string.range(nsrange: fragment.range), with: fragment.swiftFragment)
        }
        return string
    }
    
    func toSwiftString() -> String {
        var text = content

        // 2.替换基本类型
        // 降序排序
        let keys = ClassMap.map.keys.sorted { str1, str2 in
            str1.count > str2.count
        }
        // 先替换长（count大的）字符串
        keys.forEach { key in
            text.match(string: #"[^\w]+"# + key + #"[^\w]+"#).forEach { str in
                let value = str.replacingOccurrences(of: key, with: ClassMap.map[key]!)
                text = text.replacingOccurrences(of: str, with: value)
            }
        }
        
        // 3. 插入库
        var arr = text.components(separatedBy: "\n")
        
        arr.insert("import UIKit", at: 9)
        arr.insert("import SnapKit", at: 10)

        return arr.joined(separator: "\n")
    }
}

struct Translation {
    var content: String
    
    
    /// 此数组中的元素顺序不可更改
    private var featuresList: [Features.Type] = [
        // 特殊替换
        Masonry.MakeConstraintsCall.self,
        Masonry.RemakeConstraintsCall.self,
        Masonry.UpdateConstraintsCall.self,
        Masonry.MasPrefix.self,
        AddSubviewMethodCall.self,
        EmptyInitMethodCall.self,
        EmptyInitFrameMethodCall.self,
        ButtonWithTypeCall.self,
        InitMethod.self,
        LazyMethod.self,

        // 一般替换
        Property.self,
        Interface.self,
        StatementProtocol.self,
        Implementation.self,
        Mark.self,
        EqualSignLeftStatement.self,
        Method.self,
        EmptyParamMethodCall.self,
        CGSizeMakeCall.self,
        CGRectMakeCall.self,
        UIEdgeInsetsMakeCall.self,
        
        // 固定替换
        StringLiteral.self,
        ArrayLiteral.self,
        NS_ASSUME_NONNULL.self,
        Import.self,
        Semicolon.self,
        End.self,
        StatementClass.self
    ]
    
    private var fragmentList = [Fragment]()
    
}

private extension Translation {
    func match(regular: String, string: String) -> [NSTextCheckingResult] {
        do {
            let regular = try NSRegularExpression(pattern: regular, options: .anchorsMatchLines)
            return regular.matches(in: string, options: .reportCompletion, range: NSRange(location: 0, length: string.count))
        } catch {
            print("正则表达式错误", regular)
            assertionFailure(error.localizedDescription)
        }
        return []
    }
}

// MARK: - public static
extension Translation {
    
    static func main() {
        if let (hPath, mPath) = find() {
            let content = fuse(hPath: hPath, mPath: mPath)
            let path = String(hPath[hPath.startIndex..<hPath.index(hPath.count - 1)]) + "swift"
            writeFile(path: path, swiftCodeText: content)
        }
    }
    
    
    /// 查找 .h .m
    /// - Returns: .h .m的元组
    private static func find() -> (String, String)? {
        
        // 1. 过滤命令行传入的文件名
        if CommandLine.arguments.count < 3 {
            print("缺少文件路径片段 eg: MZFeedback")
            return nil
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
            return nil
        }
        
        if filePaths.count > 1 {
            print("此文件路径片段包含1个以上文件")
            print(filePaths)
            return nil
        }
        
        let path = filePaths[0]
        let hPath = directoryPath.appendingFormat("/%@", path)
        let mPath = directoryPath.appendingFormat("/%@.m", String(path.prefix(path.count - 2)))
        
        return (hPath, mPath)
    }
    
    /// 融合 .h .m
    /// - Parameters:
    ///   - hPath: .h 绝对路径
    ///   - mPath: .m 绝对路径
    private static func fuse(hPath: String, mPath: String) -> String {
        guard let content = hPath.contentString?.appendingFormat("\n%@", mPath.contentString ?? "") else {
            print("未读取到文件中的文本")
            return ""
        }
        var trans = Translation(content: content)
        
        return trans.run().toSwiftString()
    }
    
    private static func writeFile(path: String, swiftCodeText: String) {
        print(path)
        if FileManager.default.fileExists(atPath: path) {
            print("文件已存在是否继续？请输入y/n确认")
            let str = String(data: FileHandle.standardInput.availableData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            if str != "y" {
                return
            }
        }
        print(FileManager.default.createFile(atPath: path, contents: swiftCodeText.data(using: .utf8)))
    }
    
}
