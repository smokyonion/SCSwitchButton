//
//  SCSwitchButtonCell.m
//  SCSwitchButton
//
//  Created by Vincent on 1/7/11.
//  Copyright 2011 Vincent S. Wang. All rights reserved.
//

#import "SCSwitchButtonCell.h"


#define THUMB_WIDTH_FRACTION 0.45f
#define THUMB_CORNER_RADIUS 3.0f
#define FRAME_CORNER_RADIUS 5.0f

#define THUMB_GRADIENT_MAX_Y_WHITE 1.0f
#define THUMB_GRADIENT_MIN_Y_WHITE 0.9f
#define BACKGROUND_GRADIENT_MAX_Y_WHITE 0.50f
#define BACKGROUND_GRADIENT_MIN_Y_WHITE 0.75f
#define BORDER_WHITE 0.65f

#define THUMB_SHADOW_WHITE 0.0f
#define THUMB_SHADOW_ALPHA 0.5f
#define THUMB_SHADOW_BLUR 3.0f

#define ONE_THIRD  (1.0 / 3.0)
#define ONE_HALF   (1.0 / 2.0)
#define TWO_THIRDS (2.0 / 3.0)

#define DISABLED_OVERLAY_GRAY  1.0f
#define DISABLED_OVERLAY_ALPHA TWO_THIRDS

@implementation SCSwitchButtonCell

+ (BOOL)prefersTrackingUntilMouseUp 
{
	return /*YES, YES, a thousand times*/ YES;
}

+ (NSFocusRingType)defaultFocusRingType 
{
	return NSFocusRingTypeExterior;
}

- (id)initImageCell:(NSImage *)image 
{
	if ((self = [super initImageCell:image])) {
		[self setFocusRingType:[[self class] defaultFocusRingType]];
	}
	return self;
}

- (id)initTextCell:(NSString *)str 
{
	if ((self = [super initTextCell:str])) {
		[self setFocusRingType:[[self class] defaultFocusRingType]];
	}
	return self;
}

//HAX: IB (I guess?) sets our focus ring type to None for some reason. Nobody asks defaultFocusRingType unless we do it.
- (id)initWithCoder:(NSCoder *)decoder 
{
	if ((self = [super initWithCoder:decoder])) {
		[self setFocusRingType:[[self class] defaultFocusRingType]];
	}
	return self;
}

- (NSRect)thumbRectInFrame:(NSRect)cellFrame 
{
	cellFrame.size.width -= 2.0f;
	cellFrame.size.height -= 2.0f;
	cellFrame.origin.x += 1.0f;
	cellFrame.origin.y += 1.0f;
	
	NSRect thumbFrame = cellFrame;
	thumbFrame.size.width *= THUMB_WIDTH_FRACTION;
	
	NSCellStateValue state = [self state];
	switch (state) {
		case NSOffState:
			//Far left. We're already there; don't do anything.
			break;
		case NSOnState:
			//Far right.
			thumbFrame.origin.x += (cellFrame.size.width - thumbFrame.size.width);
			break;
		case NSMixedState:
			//Middle.
			thumbFrame.origin.x = (cellFrame.size.width / 2.0f) - (thumbFrame.size.width / 2.0f);
			break;
	}
	
	return thumbFrame;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView 
{
	if (tracking) trackingCellFrame = cellFrame;
	
	NSGraphicsContext *context = [NSGraphicsContext currentContext];
	CGContextRef quartzContext = [context graphicsPort];
	CGContextBeginTransparencyLayer(quartzContext, /*auxInfo*/ NULL);
	
	//Draw the background, then the frame.
	NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:FRAME_CORNER_RADIUS yRadius:FRAME_CORNER_RADIUS];
	
	NSGradient *background = [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.8f alpha:1.0f] endingColor:[NSColor colorWithCalibratedWhite:0.5f alpha:1.0f]] autorelease];
	[background drawInBezierPath:borderPath angle:90.0f];
	
	[[NSColor colorWithCalibratedWhite:BORDER_WHITE alpha:1.0f] setStroke];
	[borderPath stroke];
	
	// Draw the frame
	[self drawInteriorWithFrame:cellFrame inView:controlView];
	
	// Draw a symbol for users to easily tell the state of the button
	switch ([self state]) {
		case NSOnState:
		{	
			// Draw status mark ( | )
			NSBezierPath *statusMark = [NSBezierPath bezierPath];
			NSPoint origin;
			origin.x = NSWidth(cellFrame) * 0.3;
			origin.y = NSHeight(cellFrame) * 0.2;
			NSPoint dest;
			dest.x = NSWidth(cellFrame) * 0.3;
			dest.y = NSHeight(cellFrame) * 0.8;
			[statusMark moveToPoint:origin];
			[statusMark lineToPoint:dest];
			[statusMark setLineWidth:1.0];
			//[[NSColor colorWithCalibratedWhite:0.5f alpha:1.0f] set];
			[[NSColor whiteColor] set];
			[statusMark stroke];
			
			break;
		}
		case NSOffState:
		{	
			// Draw status mark ( O )
			NSBezierPath *statusMark = [NSBezierPath bezierPath];
			NSPoint origin;
			origin.x = NSWidth(cellFrame) * 0.7;
			origin.y = NSHeight(cellFrame) * 0.5;
			CGFloat radius = NSWidth(cellFrame) * 0.08;
			//[statusMark moveToPoint:origin]; // if you enable this it will draw the line inside the circle
			[statusMark appendBezierPathWithArcWithCenter:origin 
												   radius:radius 
											   startAngle:0 
												 endAngle:360];
			[statusMark setLineWidth:1.0];
			//[[NSColor colorWithCalibratedWhite:0.5f alpha:1.0f] set];
			[[NSColor whiteColor] set];
			[statusMark stroke];
			
			break;
		}
		default: // NSMixedState 
			break;
	}
	
	//Draw diabled status
	if (![self isEnabled]) {
		CGColorRef color = CGColorCreateGenericGray(DISABLED_OVERLAY_GRAY, DISABLED_OVERLAY_ALPHA);
		if (color) {
			CGContextSetBlendMode(quartzContext, kCGBlendModeLighten);
			CGContextSetFillColorWithColor(quartzContext, color);
			CGContextFillRect(quartzContext, NSRectToCGRect(cellFrame));
			
			CFRelease(color);
		}
	}
	
	CGContextEndTransparencyLayer(quartzContext);
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView 
{
	//Draw the thumb.
	NSRect thumbFrame = [self thumbRectInFrame:cellFrame];
	
	NSGraphicsContext *context = [NSGraphicsContext currentContext];
	[context saveGraphicsState];
	
	cellFrame.size.width -= 2.0f;
	cellFrame.size.height -= 2.0f;
	cellFrame.origin.x += 1.0f;
	cellFrame.origin.y += 1.0f;
	NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:THUMB_CORNER_RADIUS yRadius:THUMB_CORNER_RADIUS];
	[clipPath addClip];
	
	if (tracking) {
		thumbFrame.origin.x += trackingPoint.x - initialTrackingPoint.x;
		
		//Clamp.
		CGFloat minOrigin = cellFrame.origin.x;
		CGFloat maxOrigin = cellFrame.origin.x + (cellFrame.size.width - thumbFrame.size.width);
		if (thumbFrame.origin.x < minOrigin)
			thumbFrame.origin.x = minOrigin;
		else if (thumbFrame.origin.x > maxOrigin)
			thumbFrame.origin.x = maxOrigin;
		
		trackingThumbCenterX = NSMidX(thumbFrame);
	}
	
	NSBezierPath *thumbPath = [NSBezierPath bezierPathWithRoundedRect:thumbFrame xRadius:THUMB_CORNER_RADIUS yRadius:THUMB_CORNER_RADIUS];
	NSShadow *thumbShadow = [[[NSShadow alloc] init] autorelease];
	[thumbShadow setShadowColor:[NSColor colorWithCalibratedWhite:THUMB_SHADOW_WHITE alpha:THUMB_SHADOW_ALPHA]];
	[thumbShadow setShadowBlurRadius:THUMB_SHADOW_BLUR];
	[thumbShadow setShadowOffset:NSZeroSize];
	[thumbShadow set];
	[[NSColor whiteColor] setFill];
	if ([self showsFirstResponder] && ([self focusRingType] != NSFocusRingTypeNone))
		NSSetFocusRingStyle(NSFocusRingBelow);
	[thumbPath fill];
	NSGradient *thumbGradient = [[[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:THUMB_GRADIENT_MAX_Y_WHITE alpha:1.0f] endingColor:[NSColor colorWithCalibratedWhite:THUMB_GRADIENT_MIN_Y_WHITE alpha:1.0f]] autorelease];
	[thumbGradient drawInBezierPath:thumbPath angle:90.0f];
	
	[context restoreGraphicsState];
	
	if (tracking && (getenv("SCSwitchButtonCellDebug") != NULL)) {
		NSBezierPath *thumbCenterLine = [NSBezierPath bezierPath];
		[thumbCenterLine moveToPoint:(NSPoint){ NSMidX(thumbFrame), thumbFrame.origin.y +thumbFrame.size.height * ONE_THIRD }];
		[thumbCenterLine lineToPoint:(NSPoint){ NSMidX(thumbFrame), thumbFrame.origin.y +thumbFrame.size.height * TWO_THIRDS }];
		[thumbCenterLine stroke];
		
		NSBezierPath *sectionLines = [NSBezierPath bezierPath];
		if ([self allowsMixedState]) {
			[sectionLines moveToPoint:(NSPoint){ cellFrame.origin.x + cellFrame.size.width * ONE_THIRD, NSMinY(cellFrame) }];
			[sectionLines lineToPoint:(NSPoint){ cellFrame.origin.x + cellFrame.size.width * ONE_THIRD, NSMaxY(cellFrame) }];
			[sectionLines moveToPoint:(NSPoint){ cellFrame.origin.x + cellFrame.size.width * TWO_THIRDS, NSMinY(cellFrame) }];
			[sectionLines lineToPoint:(NSPoint){ cellFrame.origin.x + cellFrame.size.width * TWO_THIRDS, NSMaxY(cellFrame) }];
		} else {
			[sectionLines moveToPoint:(NSPoint){ cellFrame.origin.x + cellFrame.size.width * ONE_HALF, NSMinY(cellFrame) }];
			[sectionLines lineToPoint:(NSPoint){ cellFrame.origin.x + cellFrame.size.width * ONE_HALF, NSMaxY(cellFrame) }];
		}
		[sectionLines stroke];
	}
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView 
{
	NSPoint mouseLocation = [controlView convertPoint:[event locationInWindow] fromView:nil];
	return NSPointInRect(mouseLocation, cellFrame) ? (NSCellHitContentArea | NSCellHitTrackableArea) : NSCellHitNone;
}

- (BOOL) startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView 
{
	//We rely on NSControl behavior, so only start tracking if this is a control.
	tracking = YES;
	trackingPoint = initialTrackingPoint = startPoint;
	return [controlView isKindOfClass:[NSControl class]];
}

- (BOOL) continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView 
{
	NSControl *control = [controlView isKindOfClass:[NSControl class]] ? (NSControl *)controlView : nil;
	if (control) {
		trackingPoint = currentPoint;
		[control drawCell:self];
		return YES;
	}
	tracking = NO;
	return NO;
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag 
{
	tracking = NO;
	
	NSControl *control = [controlView isKindOfClass:[NSControl class]] ? (NSControl *)controlView : nil;
	if (control) {
		CGFloat xFraction = trackingThumbCenterX / trackingCellFrame.size.width;
		
		NSCellStateValue desiredState;
		
		if ([self allowsMixedState]) {
			if (xFraction < ONE_THIRD)
				desiredState = NSOffState;
			else if (xFraction >= TWO_THIRDS)
				desiredState = NSOnState;
			else
				desiredState = NSMixedState;
		} else {
			if (xFraction < ONE_HALF)
				desiredState = NSOffState;
			else
				desiredState = NSOnState;
		}
		
		//We actually need to set the state to the one *before* the one we want, because NSCell will advance it. I'm not sure how to thwart that without breaking -setNextState, which breaks AXPress and the space bar.
		NSCellStateValue stateBeforeDesiredState;
		switch (desiredState) {
			case NSOnState:
				if ([self allowsMixedState]) {
					stateBeforeDesiredState = NSMixedState;
					break;
				}
				//Fall through.
			case NSMixedState:
				stateBeforeDesiredState = NSOffState;
				break;
			case NSOffState:
				stateBeforeDesiredState = NSOnState;
				break;
		}
		
		[self setState:stateBeforeDesiredState];
	}
}

@end
