//
//  CCControl.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCControl.h"
#import "Constant.h"
#import "NSString+Tool.h"
#import "UIButton+Block.h"
#import <UIView+SDAutoLayout.h>
@implementation CCControl
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title backGroundImage:(NSString *)imgStr target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    if (![imgStr isEmpty] || !imgStr) {
        [button setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title backGroundImage:(NSString *)imgStr  cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    if (![imgStr isEmpty]||!imgStr) {
        [button setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateHighlighted];
    }
    button.clipsToBounds = YES;
    button.layer.cornerRadius = cornerRadius;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title backGroundColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = cornerRadius;
    button.backgroundColor = color;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (void)compressImage:(UIImage *)image limitSize:(NSUInteger)size maxSide:(CGFloat)length
           completion:(void (^)(NSData *data))block
{
    NSAssert(size > 0, @"图片的大小必须大于 0");
    NSAssert(length > 0, @"图片的最大限制边长必须大于 0");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 先按比例减少图片的分辨率
        UIImage *img = [CCControl imageWithMaxSide:length sourceImage:image];
        
        NSData *imgData = UIImageJPEGRepresentation(img, 1);
        
        NSLog(@"%lu", (unsigned long)imgData.length);
        
        if (imgData.length <= size) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 返回图片的二进制数据
                block(imgData);
            });
            
            return;
        }
        
        // 如果图片大小仍超过限制大小，则压缩图片的质量
        // 返回以 JPEG 格式表示的图片的二进制数据
        
        CGFloat quality = 0.8;
        NSInteger oldSize = imgData.length;
        do {
            @autoreleasepool {
                oldSize = imgData.length;
                imgData = UIImageJPEGRepresentation(img, quality);
                quality -= 0.1;
                NSLog(@"%lu", (unsigned long)imgData.length);
            }
        } while (imgData.length > size && oldSize != imgData.length);
        
        // 返回 压缩后的 imgData
        dispatch_async(dispatch_get_main_queue(), ^{
            // 返回图片的二进制数据
            block(imgData);
        });
    });
}


+ (void)compressImage:(UIImage *)image limitSize:(NSUInteger)size
           completion:(void (^)(NSData *data))block
{
    NSAssert(size > 0, @"图片的大小必须大于 0");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imgData = UIImageJPEGRepresentation(image, 1);
        
        NSLog(@"------->%lu", (unsigned long)imgData.length);
        
        if (imgData.length <= size) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 返回图片的二进制数据
                block(imgData);
            });
            
            return;
        }
        
        // 如果图片大小仍超过限制大小，则压缩图片的质量
        // 返回以 JPEG 格式表示的图片的二进制数据
        
        CGFloat quality = 0.8;
        NSInteger oldSize = imgData.length;
        do {
            @autoreleasepool {
                oldSize = imgData.length;
                imgData = UIImageJPEGRepresentation(image, quality);
                quality -= 0.1;
                NSLog(@"%lu", (unsigned long)imgData.length);
            }
        } while (imgData.length > size && oldSize != imgData.length);
        
        // 返回 压缩后的 imgData
        dispatch_async(dispatch_get_main_queue(), ^{
            // 返回图片的二进制数据
            block(imgData);
        });
    });
}





+ (UIImage *)imageWithMaxSide:(CGFloat)length sourceImage:(UIImage *)image
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize imgSize = CWSizeReduce(image.size, length);
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, scale);
    
    [image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)
            blendMode:kCGBlendModeNormal alpha:1.0];
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - Utility
static inline
CGSize CWSizeReduce(CGSize size, CGFloat limit)   // 按比例减少尺寸
{
    CGFloat max = MAX(size.width, size.height);
    if (max < limit) {
        return size;
    }
    
    CGSize imgSize;
    CGFloat ratio = size.height / size.width;
    
    if (size.width > size.height) {
        imgSize = CGSizeMake(limit, limit*ratio);
    } else {
        imgSize = CGSizeMake(limit/ratio, limit);
    }
    
    return imgSize;
}
@end
