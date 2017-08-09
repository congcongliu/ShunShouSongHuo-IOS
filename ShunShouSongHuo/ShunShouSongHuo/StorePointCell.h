//
//  StorePointCell.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StoreNaviCallBack)();

#import "OrderStoreModel.h"
@interface StorePointCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storePicture;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *naviButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@property (nonatomic, copy) StoreNaviCallBack callBack;
- (void)showOrderCellWithStore:(OrderStoreModel*)model andStoreNaviCallBack:(StoreNaviCallBack)callBack;
@end
