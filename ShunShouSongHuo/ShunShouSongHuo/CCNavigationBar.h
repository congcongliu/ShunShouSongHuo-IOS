//
//  CCNavigationBar.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCControl.h"
@interface CCNavigationBar : UIView
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, strong)UIView *bottomView;
- (id)initWithFrame:(CGRect)frame title:(NSString*)title;
- (id)initWithFrame:(CGRect)frame title:(NSString*)title backGroundColor:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame centerSegmented:(UISegmentedControl *)segmented;
- (id)initWithFrame:(CGRect)frame centerSegmented:(UISegmentedControl *)segmented andSegmentedFrame:(CGRect)sFrame;
- (void)addRightButton:(UIButton *)rightButton;
- (void)addLeftButton:(UIButton *)leftButton;
- (void)addNewLeftButton:(UIButton *)leftButton;
@end
