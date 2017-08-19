//
//  ReamarkTitleView.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "ReamarkTitleView.h"

@interface ReamarkTitleView (){
    UILabel *_titleLabel;
}

@end

@implementation ReamarkTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, self.frame.size.height)];
    _titleLabel.text = @"我是标题";
    [self addSubview:_titleLabel];
}

- (void)showTitleWithString:(NSString *)string{
    _titleLabel.text = string;
}

@end
