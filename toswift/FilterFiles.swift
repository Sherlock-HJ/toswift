//
//  FilterFiles  .swift
//  toswift
//
//  Created by wuhongjia on 2022/3/7.
//

import Foundation

func filterFilesMain() {
    let directoryPath = CurrentDirectoryPath
    
    let manager = FileManager.default

    // 获取资源目录下所有文件
    let resourcePaths = manager.enumerator(atPath: directoryPath)

    var files = [File]()
    while let path = (resourcePaths?.nextObject() as? String) {
        
        // 1. 只查找.h
        guard path.suffix(2) == ".h" else { continue }
        
        // 2. 查找对应的.m
        let hPath = directoryPath.appendingFormat("/%@", path)
        let mPath = directoryPath.appendingFormat("/%@.m", String(path.prefix(path.count - 2)))

        var regular = #" *#import +("|<).+("|>)"#
        let hNum = hPath.contentString?.match(string: regular).count ?? 0
        let mNum = mPath.contentString?.match(string: regular).count ?? 0

        // 3. 计算 import 数量  #" *#import +("|<).+("|>)"#   UIView  NSObject
        let number = hNum + mNum
        
        // 4. 过滤命令行传入的父类
        if CommandLine.arguments.count > 2 {
            regular = #" *@interface +\w+ *: *"# + CommandLine.arguments[2] + "$"
            let clsNum = hPath.contentString?.match(string: regular).count ?? 0
            if clsNum == 0 {
                continue
            }
        }
        
        // 5. 存储 path，import 数量
        let file = File(path: path, importNumber: number)
        files.append(file)
    }
    files.sort { file1, file2 in
        file1.importNumber > file2.importNumber
    }
    files.forEach { file in
        print(file)
    }
    print("文件数:", files.count)
}
