//
//  StorePointCell.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "StorePointCell.h"
#import "CCTool.h"
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
}

- (void)showOrderCellWithStore:(OrderStoreModel*)storeModel{
    self.storeModel = storeModel;
    self.nameLabel.text= storeModel.name;
    self.addressLabel.text = storeModel.address;
    NSString *photoUrl = [storeModel.header_photos firstObject];
    [self.storePicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QN_HEARDER_URL,photoUrl]] placeholderImage:[UIImage imageNamed:@"defaultimage"] options:SDWebImageLowPriority];
    if (!storeModel.contact_phone||[storeModel.contact_phone isEmpty]) {
        self.phoneButton.hidden = YES;
    }else{
        self.phoneButton.hidden = NO;
    }
}

- (void)imageViewTap:(UIGestureRecognizer*)sender{
    [SJAvatarBrowser showImage:(UIImageView*)sender.view];
}
- (IBAction)phoneClick:(id)sender {
    callNumber(self.storeModel.contact_phone, self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
