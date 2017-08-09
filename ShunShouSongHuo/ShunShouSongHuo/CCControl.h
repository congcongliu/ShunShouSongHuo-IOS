//
//  CCControl.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CCControl : NSObject
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title backGroundImage:(NSString *)imgStr target:(id)target action:(SEL)action;
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title backGroundImage:(NSString *)imgStr  cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action;
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title backGroundColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action;
+ (void)compressImage:(UIImage *)image limitSize:(NSUInteger)size maxSide:(CGFloat)length
           completion:(void (^)(NSData *data))block;
+ (void)compressImage:(UIImage *)image limitSize:(NSUInteger)size
           completion:(void (^)(NSData *data))block;
+ (UIImage *)imageWithMaxSide:(CGFloat)length sourceImage:(UIImage *)image;
@end
