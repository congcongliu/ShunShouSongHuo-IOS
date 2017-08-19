//
//  PhotoReamarkCell.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/11.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "PhotoReamarkCell.h"
#import "CCFile.h"
#import "Constant.h"
#import "NSString+Tool.h"
#import <UIView+SDAutoLayout.h>
#import "UIColor+CustomColors.h"
#import <UIImageView+WebCache.h>
@interface PhotoReamarkCell (){
    UILabel     *_tipLabel;
    UIView      *_backGroundView;
    UIImageView *_imageView;
    UIImageView *_bigImageView;
    UIImageView *_requiredimageImage;
}

@end

@implementation PhotoReamarkCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    _backGroundView = [[UIView alloc]initWithFrame:self.bounds];
    _backGroundView.clipsToBounds = YES;
    _backGroundView.layer.cornerRadius = 25;
    _backGroundView.layer.borderWidth = 2;
    UIColor *borderColor = UIColorFromRGB(0xcccccc);
    _backGroundView.layer.borderColor = borderColor.CGColor;
    _backGroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backGroundView];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/4, self.bounds.size.width/4, self.bounds.size.width/2, self.bounds.size.width/2)];
    _imageView.image = [UIImage imageNamed:@"q_photo"];
    [_backGroundView addSubview:_imageView];
    
    _requiredimageImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"required"]];
    _requiredimageImage.frame = CGRectMake(self.bounds.size.width-78, 0, 78, 78);
    [self addSubview:_requiredimageImage];
    _requiredimageImage.hidden = YES;
    
    _bigImageView = [[UIImageView alloc]initWithFrame:_backGroundView.bounds];
    [self addSubview:_bigImageView];
    _bigImageView.hidden = YES;
    [_bigImageView setContentMode:UIViewContentModeScaleAspectFill];
    _bigImageView.clipsToBounds = YES;
    _bigImageView.layer.cornerRadius = 25;
    
    
    _tipLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
    _tipLabel.textColor = ColorFromRGB(0x666666);
    _tipLabel.backgroundColor = ColorFromRGB(0xf2f2f2);
    _tipLabel.font = [UIFont systemFontOfSize:13];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [_backGroundView addSubview:_tipLabel];
}

- (void)showTakePhotoCellWithMinNumber:(NSInteger)minNumber andMaxNumber:(NSInteger)maxNumber{
    if (minNumber > 0) {
        _requiredimageImage.hidden = NO;
    }
    else{
        _requiredimageImage.hidden = YES;
    }
    
    _bigImageView.hidden = YES;
    _tipLabel.hidden = NO;
    _tipLabel.text = [NSString stringWithFormat:@"%ld - %ld",minNumber,maxNumber];
}

- (void)showCellWithNewModel:(TakePhotosObjectModel *)model{
    
    if ([model.key isEmpty]) {
        _bigImageView.hidden = YES;
    }
    else{
        _bigImageView.hidden = NO;
        UIImage *localImage = [self addLocalPhotoWith:model.key];
        if (localImage) {
            _bigImageView.image = localImage;
        }else {
            [_bigImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_HEARDER_URL,model.key]] placeholderImage:[UIImage imageNamed:@"defaultimage"] options:SDWebImageLowPriority];
        }
    }
    _tipLabel.hidden = YES;
}
- (UIImage*)addLocalPhotoWith:(NSString *)name{
#pragma mark --------> 缩略图
    NSString* filePath = filePathByName([NSString stringWithFormat:@"%@.jpg",name]);
    NSData* imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}
@end
