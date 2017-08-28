//
//  LoginTimeView.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/10.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "LoginTimeView.h"
#import "AppDelegate.h"
#import "Constant.h"

@interface LoginTimeView (){
    NSInteger _second;;
    NSTimer   *_timer;
    UIButton  *_timeButton;
}
@end

@implementation LoginTimeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)showLoginWindow{
    LoginTimeView *loginView = [[LoginTimeView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[AppDelegate shareAppDelegate].window addSubview:loginView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    self.backgroundColor = [UIColor clearColor];
    UIImageView * maskView = [[UIImageView alloc]initWithFrame:self.bounds];
    maskView.userInteractionEnabled = YES;
    
    if (SYSTEM_WIDTH==320) {
        if (SYSTEM_HEIGHT==480) {//4
            maskView.image = [UIImage imageNamed:@"lauch_mask_4"];
        }if (SYSTEM_WIDTH==568) {//5
            maskView.image = [UIImage imageNamed:@"lauch_mask_5"];
        }
    }else if (SYSTEM_WIDTH==375) {//6
        maskView.image = [UIImage imageNamed:@"lauch_mask_6"];
    }else if (SYSTEM_WIDTH==414) {//6+
        maskView.image = [UIImage imageNamed:@"lauch_mask_plus"];
    }
    [self addSubview:maskView];
    
    _second = 3;
    
    _timeButton = [[UIButton alloc]initWithFrame:CGRectMake(SYSTEM_WIDTH-80, SYSTEM_HEIGHT-50, 60, 30)];
    _timeButton.clipsToBounds = YES;
    _timeButton.layer.cornerRadius = 15;
    _timeButton.layer.borderWidth = 2;
    _timeButton.layer.borderColor = [UIColor blackColor].CGColor;
    _timeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_timeButton setTitle:[NSString stringWithFormat:@"%@ 3s",NSLocalizedString(@"skip", nil)] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clockRun) userInfo:nil repeats:YES];
    [_timeButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_timeButton];
}

- (void)clockRun{
    _second--;
    NSString *timeString = [NSString stringWithFormat:@"%@ %lds",NSLocalizedString(@"skip", nil),(long)_second];
    [_timeButton setTitle:timeString forState:UIControlStateNormal];
    if (_second<=0) {
        [self hidden];
    }
}

- (void)hidden{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_timer invalidate];
    }];
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
    CCLog(@"登陆计时销毁");
}

@end
