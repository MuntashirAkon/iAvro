//
//  AvroKeyboard
//
//  Created by Rifat Nabi on 6/28/12.
//  Copyright (c) 2012 OmicronLab. All rights reserved.
//

#import "Database.h"
#import "FMDatabase.h"
#import "RegexParser.h"
#import "RegexKitLite.h"

static Database* sharedInstance = nil;

@implementation Database

+ (Database *)sharedInstance  {
    if (sharedInstance == nil) {
        [[self alloc] init]; // assignment not done here, see allocWithZone
    }
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    if (sharedInstance == nil) {
        sharedInstance = [super allocWithZone:zone];
        return sharedInstance;  // assignment and return on first allocation
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (instancetype)init {
    self = [super init];    
    if (self) {
        _db = [[NSMutableDictionary alloc] initWithCapacity:0];
        _suffix = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        @autoreleasepool {
        
            NSString* filePath = [[NSBundle mainBundle] pathForResource:@"database" ofType:@"db3"];
            FMDatabase *sqliteDb = [FMDatabase databaseWithPath:filePath];
            [sqliteDb open];
            
            [self loadTableWithName:@"A" fromDatabase:sqliteDb];
            [self loadTableWithName:@"AA" fromDatabase:sqliteDb];
            [self loadTableWithName:@"B" fromDatabase:sqliteDb];
            [self loadTableWithName:@"BH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"C" fromDatabase:sqliteDb];
            [self loadTableWithName:@"CH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"D" fromDatabase:sqliteDb];
            [self loadTableWithName:@"Dd" fromDatabase:sqliteDb];
            [self loadTableWithName:@"Ddh" fromDatabase:sqliteDb];
            [self loadTableWithName:@"Dh" fromDatabase:sqliteDb];
            [self loadTableWithName:@"E" fromDatabase:sqliteDb];
            [self loadTableWithName:@"G" fromDatabase:sqliteDb];
            [self loadTableWithName:@"Gh" fromDatabase:sqliteDb];
            [self loadTableWithName:@"H" fromDatabase:sqliteDb];
            [self loadTableWithName:@"I" fromDatabase:sqliteDb];
            [self loadTableWithName:@"II" fromDatabase:sqliteDb];
            [self loadTableWithName:@"J" fromDatabase:sqliteDb];
            [self loadTableWithName:@"JH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"K" fromDatabase:sqliteDb];
            [self loadTableWithName:@"KH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"Khandatta" fromDatabase:sqliteDb];
            [self loadTableWithName:@"L" fromDatabase:sqliteDb];
            [self loadTableWithName:@"M" fromDatabase:sqliteDb];
            [self loadTableWithName:@"N" fromDatabase:sqliteDb];
            [self loadTableWithName:@"NGA" fromDatabase:sqliteDb];
            [self loadTableWithName:@"NN" fromDatabase:sqliteDb];
            [self loadTableWithName:@"NYA" fromDatabase:sqliteDb];
            [self loadTableWithName:@"O" fromDatabase:sqliteDb];
            [self loadTableWithName:@"OI" fromDatabase:sqliteDb];
            [self loadTableWithName:@"OU" fromDatabase:sqliteDb];
            [self loadTableWithName:@"P" fromDatabase:sqliteDb];
            [self loadTableWithName:@"PH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"R" fromDatabase:sqliteDb];
            [self loadTableWithName:@"RR" fromDatabase:sqliteDb];
            [self loadTableWithName:@"RRH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"RRI" fromDatabase:sqliteDb];
            [self loadTableWithName:@"S" fromDatabase:sqliteDb];
            [self loadTableWithName:@"SH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"SS" fromDatabase:sqliteDb];
            [self loadTableWithName:@"T" fromDatabase:sqliteDb];
            [self loadTableWithName:@"TH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"TT" fromDatabase:sqliteDb];
            [self loadTableWithName:@"TTH" fromDatabase:sqliteDb];
            [self loadTableWithName:@"U" fromDatabase:sqliteDb];
            [self loadTableWithName:@"UU" fromDatabase:sqliteDb];
            [self loadTableWithName:@"Y" fromDatabase:sqliteDb];
            [self loadTableWithName:@"Z" fromDatabase:sqliteDb];
            
            [self loadSuffixTableFromDatabase:sqliteDb];
            
            [sqliteDb close];
        
        }
    }
    return self;
}


- (void)loadTableWithName:(NSString*)name fromDatabase:(FMDatabase*)sqliteDb {
    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    FMResultSet *results = [sqliteDb executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", name]];
    while([results next]) {
        [items addObject:[results stringForColumn:@"Words"]];
    }
    
    /*
     NSLog(@"-----------------------------------------------------------------");
     NSLog(@"%d items added to key %@", count, name);
     NSLog(@"-----------------------------------------------------------------");
     */
    
    _db[name.lowercaseString] = items;
    
    [results close];
}

- (void)loadSuffixTableFromDatabase:(FMDatabase*)sqliteDb {
    FMResultSet *results = [sqliteDb executeQuery:[NSString stringWithFormat:@"SELECT * FROM Suffix"]];
    while([results next]) {
        _suffix[[results stringForColumn:@"English"]] = [results stringForColumn:@"Bangla"];
    }
    [results close];
}

- (NSArray*)find:(NSString*)term {
    // Left Most Character
    unichar lmc = [term.lowercaseString characterAtIndex:0];
    NSString* regex = [NSString stringWithFormat:@"^%@$", [[RegexParser sharedInstance] parse:term]];
    NSMutableArray* tableList = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableSet* suggestions = [[NSMutableSet alloc] initWithCapacity:0];
    
    switch (lmc) {
        case 'a':
            [tableList addObjectsFromArray:
             @[@"a", @"aa", @"e", @"oi", @"o", @"nya", @"y"]];
            break;
        case 'b':
            [tableList addObjectsFromArray:
             @[@"b", @"bh"]];
            break;
        case 'c':
            [tableList addObjectsFromArray:
             @[@"c", @"ch", @"k"]];
            break;
        case 'd':
            [tableList addObjectsFromArray:
             @[@"d", @"dh", @"dd", @"ddh"]];
            break;
        case 'e':
            [tableList addObjectsFromArray:
             @[@"i", @"ii", @"e", @"y"]];
            break;
        case 'f':
            [tableList addObjectsFromArray:
             @[@"ph"]];
            break;
        case 'g':
            [tableList addObjectsFromArray:
             @[@"g", @"gh", @"j"]];
            break;
        case 'h':
            [tableList addObjectsFromArray:
             @[@"h"]];
            break;
        case 'i':
            [tableList addObjectsFromArray:
             @[@"i", @"ii", @"y"]];
            break;
        case 'j':
            [tableList addObjectsFromArray:
             @[@"j", @"jh", @"z"]];
            break;
        case 'k':
            [tableList addObjectsFromArray:
             @[@"k", @"kh"]];
            break;
        case 'l':
            [tableList addObjectsFromArray:
             @[@"l"]];
            break;
        case 'm':
            [tableList addObjectsFromArray:
             @[@"h", @"m"]];
            break;
        case 'n':
            [tableList addObjectsFromArray:
             @[@"n", @"nya", @"nga", @"nn"]];
            break;
        case 'o':
            [tableList addObjectsFromArray:
             @[@"a", @"u", @"uu", @"oi", @"o", @"ou", @"y"]];
            break;
        case 'p':
            [tableList addObjectsFromArray:
             @[@"p", @"ph"]];
            break;
        case 'q':
            [tableList addObjectsFromArray:
             @[@"k"]];
            break;
        case 'r':
            [tableList addObjectsFromArray:
             @[@"rri", @"h", @"r", @"rr", @"rrh"]];
            break;
        case 's':
            [tableList addObjectsFromArray:
             @[@"s", @"sh", @"ss"]];
            break;
        case 't':
            [tableList addObjectsFromArray:
             @[@"t", @"th", @"tt", @"tth", @"khandatta"]];
            break;
        case 'u':
            [tableList addObjectsFromArray:
             @[@"u", @"uu", @"y"]];
            break;
        case 'v':
            [tableList addObjectsFromArray:
             @[@"bh"]];
            break;
        case 'w':
            [tableList addObjectsFromArray:
             @[@"o"]];
            break;
        case 'x':
            [tableList addObjectsFromArray:
             @[@"e", @"k"]];
            break;
        case 'y':
            [tableList addObjectsFromArray:
             @[@"i", @"y"]];
            break;
        case 'z':
            [tableList addObjectsFromArray:
             @[@"h", @"j", @"jh", @"z"]];
            break;
        default:
            break;
    }
    
    for (NSString* table in tableList) {
        NSArray* tableData = _db[table];
        for (NSString* tmpString in tableData) {
            if ([tmpString isMatchedByRegex:regex]) {
                [suggestions addObject:tmpString];
            }
        }
    }
    
    
    return suggestions.allObjects;
}

- (NSString*)banglaForSuffix:(NSString*)suffix {
    return _suffix[suffix];
}

@end
