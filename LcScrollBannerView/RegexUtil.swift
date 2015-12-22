//
//  RegexUtil.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/2/4.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation

class RegexUtil {
    
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: [], range:NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
}