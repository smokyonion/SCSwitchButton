//
//  NSColor+SCAdditions.h
//  SCSwitchButton
//
//  Created by vincent on 1/7/11.
//  Copyright 2011 Ortery Technologies, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (SCAdditions)

+ (NSColor *)colorWithHexColorString:(NSString*)aColorString;
+ (NSColor *)colorWithRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
