//
//  AvroKeyboard
//
//  Created by Rifat Nabi on 6/21/12.
//  Copyright (c) 2012 OmicronLab. All rights reserved.
//

#import "Candidates.h"

static Candidates *_sharedInstance = nil;

@implementation Candidates

+ (void)allocateSharedInstanceWithServer:(IMKServer *)server {
    if (_sharedInstance == nil) {
        _sharedInstance = [[self alloc] initWithServer:server panelType:kIMKSingleColumnScrollingCandidatePanel];
        [_sharedInstance setAttributes:@{IMKCandidatesSendServerKeyEventFirst: @YES}];
        
        [_sharedInstance setDismissesAutomatically:NO];
    }
}

+ (void)deallocateSharedInstance {
}

+ (Candidates *)sharedInstance; {
	return _sharedInstance;
}

@end
