//
//  main.swift
//  toswift
//
//  Created by wuhongjia on 2022/3/7.
//

import Foundation

// 获得命令行参数

if CommandLine.arguments.count < 2 {
    fatalError("缺少参数")
}

guard let arg = Arguments(rawValue: CommandLine.arguments[1]) else {
    fatalError("参数错误")
}

switch arg {
case .f, .filter:
    filterFilesMain()
case .t, .translation:
    Translation.main()
}
