//
//  CacheManager.swift
//  AvroKeyboard
//
//  Created by Max on 4/25/17.
//
//

import Foundation


@objc public class CacheManager: NSObject {
    fileprivate(set) var weightCache:[String:String] = [:]
    fileprivate(set) var phoneticCache:[String:Array<Any>] = [:]
    fileprivate(set) var recentBaseCache:[String:Array<Any>] = [:]
    
    public static let shared = CacheManager()
    
    public func persist() {
        (weightCache as NSDictionary).write(toFile: filePath, atomically: true)
    }
    
    var sharedFolder: String {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        return ((paths[0] as NSString).appendingPathComponent("OmicronLab") as NSString).appendingPathComponent("Avro Keyboard")
    }
    
    var filePath: String { return  (sharedFolder as NSString).appendingPathComponent("weight.plist") }
    
    public override init() {
        super.init()
        
        if FileManager.default.fileExists(atPath: filePath),
            let dictionary = NSDictionary(contentsOfFile: filePath) as? [String : String] {
            weightCache = dictionary
        } else if FileManager.default.fileExists(atPath: sharedFolder) == false {
            //io should be done on background thread
            DispatchQueue.global(priority: .background).async {
                try? FileManager.default.createDirectory(atPath: self.sharedFolder, withIntermediateDirectories: true, attributes: nil)
            }
        }
    }
    
    deinit {
        persist()
    }
}

// TODO - Rewrite the CacheManager with meaningful methods

// Weight Cache (default for String)
public extension CacheManager {
    public func string(forKey key:String) -> String? {
        return weightCache[key]
    }
    
    public func removeString(forKey key:String) {
        weightCache[key] = nil
    }
    
    public func setString(_ string:String, forKey key:String) {
        weightCache[key] = string
    }
}

// Phonetic Cahce (default for Array)
public extension CacheManager {
    public func array(forKey key:String) -> Array<Any>? {
        return phoneticCache[key]
    }
    
    public func setArray(_ array:Array<Any>, forKey key:String) {
        phoneticCache[key] = array
    }
}


// Base Cahce
public extension CacheManager {
    public func removeAllBase() {
        recentBaseCache.removeAll()
    }
    
    public func base(forKey key:String) -> Array<Any>? {
        return recentBaseCache[key]
    }
    
    public func setBase(_ base:Array<Any>, forKey key:String) {
        recentBaseCache[key] = base
    }
}
