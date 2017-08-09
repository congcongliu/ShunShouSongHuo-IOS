//
//  StorePointAnnotationView.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "StorePointAnnotationView.h"
#import "UIColor+CustomColors.h"
#define kWidth  52.f
#define kHeight 52.f

@interface StorePointAnnotationView ()
@property (nonatomic, strong) UIView *maskView;
@end

@implementation StorePointAnnotationView

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13 , 13, kWidth/2, kHeight/2)];
        [self addSubview:self.portraitImageView];
        
        self.maskView = [[UIView alloc]initWithFrame:self.bounds];
        self.maskView.clipsToBounds = YES;
        self.maskView.layer.cornerRadius = 26;
        self.maskView.backgroundColor = [UIColor customBlueColor];
        self.maskView.alpha = 0;//0.4
        [self addSubview:self.maskView];
    }
    
    return self;
}
- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        self.maskView.alpha = 0.4;
    }
    else
    {
        self.maskView.alpha = 0;
    }
    
    [super setSelected:selected animated:animated];
}
@end
