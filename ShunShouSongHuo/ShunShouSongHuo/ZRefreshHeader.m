//
//  ZRefreshHeader.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/5/11.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "ZRefreshHeader.h"
#import "Constant.h"
#import <UIView+SDAutoLayout.h>

@interface ZRefreshHeader (){
    UIView *_bottomView;
}

@end

@implementation ZRefreshHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    self.stateLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=30; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown-%lu.png", (unsigned long)i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    //[self setImages:idleImages duration:0.8 forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=24; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh-%lu.png", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    
    //[self setImages:refreshingImages forState:MJRefreshStatePulling];
    [self setImages:refreshingImages duration:0.8 forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片

    //[self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    [self setImages:refreshingImages duration:0.8 forState:MJRefreshStateRefreshing];
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
}
#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.alpha = 1;
    _bottomView.frame = CGRectMake(0, self.bounds.size.height-6, self.bounds.size.width, 6);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    self.alpha = 1;
}

@end
