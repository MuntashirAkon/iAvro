//
//  AvroKeyboard
//
//  Created by Rifat Nabi on 6/21/12.
//  Copyright (c) 2012 OmicronLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>

#import "AvroParser.h"
#import "Suggestion.h"
#import "Candidates.h"

//Each input method needs a unique connection name. 
//Note that periods and spaces are not allowed in the connection name.
const NSString* kConnectionName = @"Avro_Keyboard_Connection";

//let this be a global so our application controller delegate can access it easily
IMKServer* server;

int main(int argc, char *argv[]) {
    
    NSString* identifier;
	
    [AvroParser sharedInstance];
    [Suggestion sharedInstance];
    
	//find the bundle identifier and then initialize the input method server
    identifier = [[NSBundle mainBundle] bundleIdentifier];
    server = [[IMKServer alloc] initWithName:(NSString*)kConnectionName bundleIdentifier:identifier];
	[Candidates allocateSharedInstanceWithServer:server];
    
    //load the bundle explicitly because in this case the input method is a background only application 
    if ([[NSBundle mainBundle] respondsToSelector:@selector(loadNibNamed:owner:topLevelObjects:)]) {
        // We're running on Mountain Lion or higher
        [[NSBundle mainBundle] loadNibNamed:@"MainMenu"
                                      owner:[NSApplication sharedApplication]
                            topLevelObjects:nil];
    } else {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [NSBundle loadNibNamed:@"MainMenu"
                         owner:[NSApplication sharedApplication]];
        #pragma clang diagnostic pop
    }

    //finally run everything
	[[NSApplication sharedApplication] run];
	
    [Candidates deallocateSharedInstance];
    return 0;
}
