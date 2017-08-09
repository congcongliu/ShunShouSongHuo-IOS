
//
//  NoDataView.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/5/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "NoDataView.h"
#import "Constant.h"
#import <UIView+SDAutoLayout.h>

@implementation NoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emptylist"]];
    [self addSubview:self.imageView ];
    self.messageLabel = [[UILabel alloc]init];
    _messageLabel.numberOfLines = 0;
    _messageLabel.font = [UIFont systemFontOfSize:14];
    _messageLabel.text = @"没有找到附近的门店";
    _messageLabel.textColor = UIColorFromRGB(0x999999);
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel];
    
    self.imageView .sd_layout
    .centerXEqualToView(self)
    .centerYIs(self.height/2-40)
    .widthIs(self.imageView .width)
    .heightIs(self.imageView .height);
    
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    _messageLabel.sd_layout
    .widthIs(300)
    .heightIs(45)
    .centerXEqualToView(self)
    .topSpaceToView(self.imageView,20);
}
@end
