//
//  SCSwitchButton.m
//  SCSwitchButton
//
//  Created by Vincent on 1/7/11.
//  Copyright 2011 Vincent S. Wang. All rights reserved.
//

#import "SCSwitchButton.h"
#import "SCSwitchButtonCell.h"

@implementation SCSwitchButton

+ (void)initialize 
{
	[self setCellClass:[SCSwitchButtonCell class]];
}

- (void)awakeFromNib
{
	[[self class] setCellClass:[SCSwitchButtonCell class]];
}

- (void)keyDown:(NSEvent *)event
{
	unichar character = [[event characters] characterAtIndex:0UL];
	switch (character) 
	{
		case NSLeftArrowFunctionKey:
		case NSRightArrowFunctionKey:
			//Do nothing (yet). We'll handle this in keyUp:.
			break;
		default:
			[super keyDown:event];
			break;
	}
}

- (void)keyUp:(NSEvent *)event 
{
	unichar character = [[event characters] characterAtIndex:0UL];
	switch (character) 
	{
		case NSLeftArrowFunctionKey:
			switch ([self state]) 
			{
				case NSOffState:
					NSBeep();
					break;
				case NSMixedState:
					[self setState:NSOffState];
					break;
				case NSOnState:
					if ([self allowsMixedState])
						[self setState:NSMixedState];
					else
						[self setState:NSOffState];
					break;
			}
			break;
		case NSRightArrowFunctionKey:
			switch ([self state]) 
			{
				case NSOffState:
					if ([self allowsMixedState])
						[self setState:NSMixedState];
					else
						[self setState:NSOnState];
					break;
				case NSMixedState:
					[self setState:NSOnState];
					break;
				case NSOnState:
					NSBeep();
					break;
			}
			break;
		default:
			[super keyUp:event];
			break;
	}
}

@end
