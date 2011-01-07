//
//  SCSwitchButtonCell.h
//  SCSwitchButton
//
//  Created by Vincent on 1/7/11.
//  Copyright 2011 Vincent S. Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SCSwitchButtonCell : NSButtonCell {
	BOOL tracking;
	NSPoint initialTrackingPoint, trackingPoint;
	NSRect trackingCellFrame; //Set by drawWithFrame: when tracking is true.
	CGFloat trackingThumbCenterX; //Set by drawWithFrame: when tracking is true.
}

@end
