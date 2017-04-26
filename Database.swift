//
//  Database.swift
//  AvroKeyboard
//
//  Created by Mamnun Bhuiyan on 27/4/17.
//
//

import Foundation

/// A helper/utility class that loads the database.db3 sqlite database which is basically a bengaliy dictionary. The db file contains huge list of legit bangla words partitioned into multiple tables by word-prefix. Also contains available bengali suffix eg. ta, khana which can be used with other words like boita, teblekhana etc.

@objc public class Database: NSObject {
    fileprivate var db:[String:[String]] = [:]
    fileprivate var suffixList:[String:String] = [:]
    
    static let shared: Database = Database()
    
    static let tables:[String] = ["A", "AA", "B", "BH",
                           "C", "CH", "D", "Dd", "Ddh", "Dh",
                           "E", "G", "Gh", "H", "I", "II",
                           "J", "JH", "K", "KH", "Khandatta",
                           "L", "M", "N", "NGA", "NN", "NYA",
                           "O","OI", "OU", "P", "PH",
                           "R", "RR", "RRH", "RRI",
                           "S", "SH", "SS",
                           "T", "TH", "TT", "TTH",
                           "U", "UU", "Y", "Z"];
    
    static let prefixToTableMap: [Character:[String]] = [
        "a" : ["a", "aa", "e", "oi", "o", "nya", "y"],
        "b" : ["b", "bh"],
        "c" : ["c", "ch", "k"],
        "d" : ["d", "dh", "dd", "ddh"],
        "e" : ["i", "ii", "e", "y"],
        "f" : ["ph"],
        "g" : ["g", "gh", "j"],
        "h" : ["h"],
        "i" : ["i", "ii", "y"],
        "j" : ["j", "jh", "z"],
        "k" : ["k", "kh"],
        "l" : ["l"],
        "m" : ["h", "m"],
        "n" : ["n", "nya", "nga", "nn"],
        "o" : ["a", "u", "uu", "oi", "o", "ou", "y"],
        "p" : ["p", "ph"],
        "q" : ["k"],
        "r" : ["rri", "h", "r", "rr", "rrh"],
        "s" : ["s", "sh", "ss"],
        "t" : ["t", "th", "tt", "tth", "khandatta"],
        "u" : ["u", "uu", "y"],
        "v" : ["bh"],
        "w" : ["o"],
        "x" : ["e", "k"],
        "y" : ["i", "y"],
        "z" : ["h", "j", "jh", "z"]
    ]
    
    override init() {
        super.init()
        
        autoreleasepool {
            guard let filePath = Bundle.main.path(forResource: "database", ofType: "db3"),
                let dbase = FMDatabase(path: filePath) else {
                    return
            }
            dbase.open()
            
            for tableName in Database.tables {
                loadTable(name: tableName, from: dbase)
            }
            loadSuffixTable(from: dbase)
            
            dbase.close()
        }
    }
    
    
    public func find(_ term:String) -> [String] {
        //lmc = left most character
        guard let lmc = term.characters.first else { return [] }
        
        guard let parsed = RegexParser.sharedInstance().parse(term) else { return [] }
        
        let regex = "^\(parsed)$"
        let tableList: [String] = Database.prefixToTableMap[lmc] ?? []
        
        let suggestions: [String] =
            tableList.map{db[$0]} // [ [String]? ]
                .flatMap{$0} // [ [String] ]
                .flatMap{$0} // [String]
                .filter({ ($0 as NSString).isMatched(byRegex: regex) })
        
        return suggestions
    }
    public func bangla(forSuffix suffix:String) -> String? {
        return suffixList[suffix]
    }
}

fileprivate extension Database {
    func loadSuffixTable(from dbase:FMDatabase) {
        guard let result = dbase.executeQuery("SELECT * FROM Suffix", withArgumentsIn: nil) else { return }
        while result.next() == true {
            guard let eng = result.string(forColumn: "English"), let bn = result.string(forColumn: "Bangla") else { continue }
            suffixList[eng] = bn
        }
    }
    
    func loadTable(name:String, from dbase:FMDatabase) {
        guard let result = dbase.executeQuery("SELECT * FROM \(name)", withArgumentsIn: nil) else { return }
        var items:[String] = []
        while result.next() {
            guard let item = result.string(forColumn: "Words") else { continue }
            items.append(item)
        }
        db[name.lowercased()] = items
    }
}
