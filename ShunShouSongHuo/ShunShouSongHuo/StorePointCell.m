//
//  StorePointCell.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "StorePointCell.h"
#import "Constant.h"
#import "NSString+Tool.h"
#import "SJAvatarBrowser.h"
#import <UIImageView+WebCache.h>

@implementation StorePointCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.storePicture.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    self.storePicture.clipsToBounds = YES;
    [self.storePicture addGestureRecognizer:tap];
    [self.storePicture setContentMode:UIViewContentModeScaleAspectFill];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.phoneButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.phoneButton.layer.borderWidth = 2;
}

- (void)showOrderCellWithStore:(OrderStoreModel*)model andStoreNaviCallBack:(StoreNaviCallBack)callBack{
    self.callBack = callBack;
    self.nameLabel.text= model.name;
    self.addressLabel.text = model.address;
    NSString *photoUrl = [model.header_photos firstObject];
    [self.storePicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_HEARDER_URL,photoUrl]] placeholderImage:[UIImage imageNamed:@"defaultimage"] options:SDWebImageLowPriority];
    self.phoneButton.frame = CGRectMake(15, 72, SYSTEM_WIDTH/3, 40);
    self.naviButton.frame = CGRectMake(SYSTEM_WIDTH/3+30, 72, SYSTEM_WIDTH/3*2-45, 40);
}

- (void)imageViewTap:(UIGestureRecognizer*)sender{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}

- (IBAction)naviButtonClick:(id)sender {
    if (self.callBack) {
        self.callBack();
    }
}

- (IBAction)phoneButtonClick:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
