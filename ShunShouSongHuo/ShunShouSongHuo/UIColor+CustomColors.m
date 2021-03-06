//
//  UIColor+CustomColors.m
//  Popping
//
//  Created by André Schneider on 25.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)customGrayColor
{
    return ColorFromRGB(0xdddddd);
}

+ (UIColor *)customRedColor
{
    return ColorFromRGB(0xff3b30);
}
+ (UIColor *)customPinkColor
{
    return ColorFromRGB(0xfeebea);
}
+ (UIColor *)customYellowColor
{
    return ColorFromRGB(0xffcf00);
}

+ (UIColor *)customGreenColor
{
    return ColorFromRGB(0x9ee32a);
}

+ (UIColor *)customBlueColor
{
    return ColorFromRGB(0x23bcff);
}

+ (UIColor *)customNaviColor
{
    return ColorFromRGB(0xf9f9f9);
}
+ (UIColor *)grayTextColor{
    return ColorFromRGB(0x999999);
}
#pragma mark - Private class methods

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}

@end
