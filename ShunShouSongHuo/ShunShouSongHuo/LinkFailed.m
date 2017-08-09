//
//  LinkFailed.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/5/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "LinkFailed.h"
#import "Constant.h"
#import <UIView+SDAutoLayout.h>
@implementation LinkFailed

- (instancetype)initWithFrame:(CGRect)frame callBack:(LinkFailedTapCallBackBlock )callBackHandler
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tapCallBackHandler = callBackHandler;
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"linkfailed"]];
    [self addSubview:imageView];
    self.messageLabel = [[UILabel alloc]init];
    _messageLabel.text = @"网络连接失败，请点击再次尝试";
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:_messageLabel];
    imageView.sd_layout
    .centerXEqualToView(self)
    .centerYIs(self.height/2-40)
    .autoHeightRatio(1);
    _messageLabel.sd_layout
    .widthIs(300)
    .heightIs(45)
    .centerXEqualToView(self)
    .topSpaceToView(imageView,10);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(id)sender{
    if (self.tapCallBackHandler) {
        self.tapCallBackHandler();
    }
}

@end
