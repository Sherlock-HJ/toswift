//
//  Masonry.swift
//  toswift
//
//  Created by wuhongjia on 2022/4/6.
//

import Foundation
struct Masonry {
    /**
    swift
     ```
     tableView.snp.makeConstraints { make in
         make.top.equalTo(head.snp.bottom)
         make.left.bottom.right.equalTo(0)
     }
     ```
    oc
     ```
     [lineView mas_makeConstraInts:^(MASConstraIntMaker *make) {
         make.left.equalTo(self.evaluationBtn.mas_right)
         make.centerY.equalTo(self)
     }]
     ```
     */
    struct MakeConstraintsCall: Features, Fragment {
        static var regular: String {
            #"\[.+ +mas_makeConstraints: *\^\( *MASConstraintMaker[ \*]+make *\) *\{[^\}]*\}\]"#
        }
        
        static var fragmentType: Fragment.Type {
            Self.self
        }
        
        var ocFragment: String
        
        var range: NSRange

        var swiftFragment: String {
            let arr = ocFragment.replacingOccurrences(of: " ", with: "").components(separatedBy: "mas_makeConstraints:^(MASConstraintMaker*make){")
            guard arr.count == 2 else { return ocFragment }
            
            let view = arr[0].replacingOccurrences(of: "[", with: "")
            let functionBody = arr[1].replacingOccurrences(of: "]", with: "")

            return "\(view).snp.makeConstraints { make in \(functionBody)"
        }

        
    }
    
    struct RemakeConstraintsCall: Features, Fragment {
        static var regular: String {
            #"\[.+ +mas_remakeConstraints: *\^\( *MASConstraintMaker[ \*]+make *\) *\{[^\}]*\}\]"#
        }
        
        static var fragmentType: Fragment.Type {
            Self.self
        }
        
        var ocFragment: String
        
        var range: NSRange

        var swiftFragment: String {
            let arr = ocFragment.replacingOccurrences(of: " ", with: "").components(separatedBy: "mas_remakeConstraints:^(MASConstraintMaker*make){")
            guard arr.count == 2 else { return ocFragment }
            
            let view = arr[0].replacingOccurrences(of: "[", with: "")
            let functionBody = arr[1].replacingOccurrences(of: "]", with: "")

            return "\(view).snp.remakeConstraints { make in \(functionBody)"
        }

    }
    
    struct UpdateConstraintsCall: Features, Fragment {
        static var regular: String {
            #"\[.+ +mas_updateConstraints: *\^\( *MASConstraintMaker[ \*]+make *\) *\{[^\}]*\}\]"#
        }
        
        static var fragmentType: Fragment.Type {
            Self.self
        }
        
        var ocFragment: String
        
        var range: NSRange

        var swiftFragment: String {
            let arr = ocFragment.replacingOccurrences(of: " ", with: "").components(separatedBy: "mas_updateConstraints:^(MASConstraintMaker*make){")
            guard arr.count == 2 else { return ocFragment }
            
            let view = arr[0].replacingOccurrences(of: "[", with: "")
            let functionBody = arr[1].replacingOccurrences(of: "]", with: "")

            return "\(view).snp.updateConstraints { make in \(functionBody)"
        }

        
    }
    
    struct MasPrefix: Features, Fragment {
        static var regular: String {
            #"\.mas_"#
        }
        
        static var fragmentType: Fragment.Type {
            Self.self
        }
        
        var ocFragment: String
        
        var range: NSRange

        var swiftFragment: String {
            "."
        }

        
    }
    

}
