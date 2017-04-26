//
//  AutoCorrect.swift
//  AvroKeyboard
//
//  Created by Mamnun Bhuiyan on 26/4/17.
//
//

import Foundation

@objc public class AutoCorrect: NSObject {
    var entries: [String: String] = [:]
    
    static let shared: AutoCorrect = AutoCorrect()
    
    override init() {
        super.init()
        guard let filePath = Bundle.main.path(forResource: "autodict", ofType: "plist") else { return }
        
        if FileManager.default.fileExists(atPath: filePath) {
            if let dict = NSDictionary(contentsOfFile: filePath) as? [String:String] {
                entries = dict
            }
        }
    }
    
    public func find(_ term:String) -> String? {
        guard let fixedTerm = AvroParser.sharedInstance().fix(term) else { return nil }
        return entries[fixedTerm]
    }
}
