//
//  AutoCorrectItem.swift
//  AvroKeyboard
//
//  Created by Max on 4/25/17.
//
//

import Foundation


@objc public class AutoCorrectItem: NSObject {
    var replace: String
    var with: String
    
    init(replace:String = "replace", with:String = "with") {
        self.replace = replace
        self.with = with
        super.init()
    }
}
