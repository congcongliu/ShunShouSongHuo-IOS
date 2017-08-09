//
//  LinkFailed.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/5/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LinkFailedTapCallBackBlock)(void);
@interface LinkFailed : UIView
@property (nonatomic, strong)UILabel *messageLabel;
@property (nonatomic, copy)LinkFailedTapCallBackBlock tapCallBackHandler;
- (instancetype)initWithFrame:(CGRect)frame callBack:(LinkFailedTapCallBackBlock )callBackHandler;
@end
