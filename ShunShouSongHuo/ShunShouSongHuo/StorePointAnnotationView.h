//
//  StorePointAnnotationView.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface StorePointAnnotationView : MAAnnotationView
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIImage *portrait;

@end
