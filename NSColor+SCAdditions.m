//
//  NSColor+SCAdditions.m
//  SCSwitchButton
//
//  Created by vincent on 1/7/11.
//  Copyright 2011 Ortery Technologies, Inc. All rights reserved.
//

#import "NSColor+SCAdditions.h"


@implementation NSColor (SCAdditions)

+ (NSColor *)colorWithHexColorString:(NSString*)aColorString
{
	NSColor* result    = nil;
	unsigned colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != aColorString)
	{
		NSScanner* scanner = [NSScanner scannerWithString:aColorString];
		(void) [scanner scanHexInt:&colorCode]; // ignore error
	}
	redByte   = (unsigned char)(colorCode >> 16);
	greenByte = (unsigned char)(colorCode >> 8);
	blueByte  = (unsigned char)(colorCode);     // masks off high bits
	
	result = [NSColor colorWithCalibratedRed:(CGFloat)(redByte / 0xff)
									   green:(CGFloat)(greenByte / 0xff) 
										blue:(CGFloat)(blueByte / 0xff) 
									   alpha:1.0];
	return result;
}

+ (NSColor *)colorWithRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
	NSColorSpace *sRGB = [NSColorSpace sRGBColorSpace]; // available in 10.5 or above
	
	CGFloat components[3] = { red, green, blue };
	NSColor *reslut = [NSColor colorWithColorSpace:sRGB components:components count:3];
	
	return reslut;
}

@end
