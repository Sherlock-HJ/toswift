//
//  Features.swift
//  toswift
//
//  Created by wuhongjia on 2022/3/31.
//

import Foundation

protocol Features {
    
    /// 特征正则
    static var regular: String { get }
    

    static var fragmentType: Fragment.Type { get }
    /**
     1. 遍历特征数组，将里边的特征正则取出挨个`match .h .m``融合后的文本`
     2.转译成`Swift`并记录`nsrange`
     3.按`nsrange` 替换`融合后的文本` `Features`对象的`toSwiftString`
     */
    
}

protocol Fragment {
    
    init(ocFragment: String, range: NSRange)
    
    var ocFragment: String { get set }
        
    var range: NSRange { get set }
    
    var swiftFragment: String { get }

}
