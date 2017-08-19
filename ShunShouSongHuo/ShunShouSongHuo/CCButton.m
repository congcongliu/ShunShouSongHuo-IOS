//
//  CCButton.m
//
//
//  Created by CongCong on 16/9/10.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCButton.h"
#import "UIColor+CustomColors.h"
@implementation CCButton
+(UIButton *)ButtonWithFrame:(CGRect)frame cornerradius:(CGFloat )radius title:(NSString *)title titleColor:(UIColor*)titleColor titleFont:(UIFont*)titleFont normalBackGrondImage:(UIImage *)normalImage highLightImage:(UIImage *)highLightImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIButton *)ButtonCornerradius:(CGFloat )radius title:(NSString *)title titleColor:(UIColor*)titleColor titleSeletedColor:(UIColor*)titleSeletedColor titleFont:(UIFont*)titleFont normalBackGrondImage:(UIImage *)normalImage seletedImage:(UIImage *)seletedImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 2;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleSeletedColor forState:UIControlStateSelected];
    button.titleLabel.font = titleFont;
    if (normalImage) {
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    }else{
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    [button setBackgroundImage:seletedImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIButton *)ButtonCornerradius:(CGFloat )radius normalBackGrondImage:(UIImage *)normalImage heighLightImage:(UIImage *)heighLightedImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
    button.layer.borderColor = [UIColor customGrayColor].CGColor;
    button.layer.borderWidth = 1;
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:heighLightedImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
