//
//  CCNavigationBar.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCNavigationBar.h"
#import "CCTool.h"
#import "Constant.h"
#import "NSString+Tool.h"
#import "UIColor+CustomColors.h"
#define LABELHEIGHT 24

@interface CCNavigationBar ()

@end


@implementation CCNavigationBar

- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        int originy=(SYSTEM_NAVI_HEIGHT-LABELHEIGHT)/2+statusBarHeight()/2;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //        UIColor *startColor =UIColorFromRGB(0x74C4DF);
        UIColor *endColor = UIColorFromRGB(NaviColor);
        gradient.colors = [NSArray arrayWithObjects:(id)[endColor CGColor],
                           (id)[endColor CGColor],nil];
        [self.layer insertSublayer:gradient atIndex:0];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, originy, frame.size.width, LABELHEIGHT)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor blackColor];
        _label.font = fontBysize(18);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text=title;
        _label.userInteractionEnabled=YES;
        [self addSubview:_label];
        
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 63.5, SYSTEM_WIDTH, 0.5)];
        _bottomView.backgroundColor = [UIColor grayTextColor];
        [self addSubview:_bottomView];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame title:(NSString*)title backGroundColor:(UIColor *)color;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        int originy=(SYSTEM_NAVI_HEIGHT-LABELHEIGHT)/2+statusBarHeight()/2;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        gradient.colors = [NSArray arrayWithObjects:(id)[color CGColor],
                           (id)[color CGColor],nil];
        [self.layer insertSublayer:gradient atIndex:0];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, originy, frame.size.width, LABELHEIGHT)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor blackColor];
        _label.font = fontBysize(18);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text=title;
        _label.userInteractionEnabled=YES;
        [self addSubview:_label];
    }
    return self;
}

- (void)addLeftButton:(UIButton *)leftButton
{
    self.leftButton = leftButton;
    leftButton.frame = CGRectMake(0, 20, 44, 44);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"arrowleft-h"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"arrowleft-n"] forState:UIControlStateHighlighted];
    [self addSubview:leftButton];
}

- (void)addNewLeftButton:(UIButton *)leftButton
{
    self.leftButton = leftButton;
    leftButton.frame = CGRectMake(0, 20, 44, 44);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"new_back_seleted"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"new_back_normal"] forState:UIControlStateHighlighted];
    [self addSubview:leftButton];
}


- (void)addRightButton:(UIButton *)rightButton
{
    self.rightButton = rightButton;
    
    CGRect rect = rightButton.frame;
    rect.origin.x = self.frame.size.width - rect.size.width;
    rect.origin.y = (SYSTEM_HEIGHT-rect.size.height)/2+statusBarHeight()/2;
    rightButton.frame = rect;
    //rightButton.backgroundColor = [UIColor redColor];
    [self addSubview:rightButton];
}


- (id)initWithFrame:(CGRect)frame centerSegmented:(UISegmentedControl *)segmented
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        //int originy=(SYSTEMTITLEHEIGHT-LABELHEIGHT)/2+statusBarHeight()/2;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //        UIColor *startColor =UIColorFromRGB(0x74C4DF);
        UIColor *endColor = UIColorFromRGB(NaviColor);
        gradient.colors = [NSArray arrayWithObjects:(id)[endColor CGColor],
                           (id)[endColor CGColor],nil];
        [self.layer insertSublayer:gradient atIndex:0];
        segmented.frame = CGRectMake(frame.size.width/2-100, 27, 200, 30);
        [self addSubview:segmented];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame centerSegmented:(UISegmentedControl *)segmented andSegmentedFrame:(CGRect)sFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        //int originy=(SYSTEMTITLEHEIGHT-LABELHEIGHT)/2+statusBarHeight()/2;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //        UIColor *startColor =UIColorFromRGB(0x74C4DF);
        UIColor *endColor = UIColorFromRGB(NaviColor);
        gradient.colors = [NSArray arrayWithObjects:(id)[endColor CGColor],
                           (id)[endColor CGColor],nil];
        [self.layer insertSublayer:gradient atIndex:0];
        segmented.frame = sFrame;
        [self addSubview:segmented];
    }
    return self;
}


@end
