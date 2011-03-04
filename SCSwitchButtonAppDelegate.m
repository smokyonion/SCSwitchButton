//
//  SCSwitchButtonAppDelegate.m
//  SCSwitchButton
//
//  Created by Vincent on 1/7/11.
//  Copyright 2011 Vincent S. Wang. All rights reserved.
//

#import "SCSwitchButtonAppDelegate.h"
#import "SCSwitchButton.h"

@implementation SCSwitchButtonAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (IBAction)switchStatus:(id)sender
{
	if ([sender isKindOfClass:[SCSwitchButton class]]) {
		switch ([sender state]) {
			case NSOffState:
				[sender setState:NSOnState];
				break;
			case NSOnState:
				[sender setState:NSOffState];
				break;
			default: //NSMixedState
				break;
		}
	}
}

@end
