//
//  UIControl+ButtonClick.h
//  cmfieldwork
//
//  Created by chance on 15/11/25.
//  Copyright (c) 2015年 Shanghai Zhongyi Communication Technology Engieering Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (ButtonClick)

@property(nonatomic, assign) NSTimeInterval acceptEventTime;

@property(nonatomic, assign) BOOL ignoreEvent;

@end
