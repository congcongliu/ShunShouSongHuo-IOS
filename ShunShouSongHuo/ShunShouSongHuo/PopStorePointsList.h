//
//  PopStorePointsList.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OrderStorePopListCallBack)();
#import "OrderStoreModel.h"
@interface PopStorePointsList : UIView
@property (nonatomic, assign) BOOL isShow;
- (void)showPopViewWith:(OrderStoreModel *)model andPopListCallBack:(OrderStorePopListCallBack)callback;
- (void)hidden;
@end
