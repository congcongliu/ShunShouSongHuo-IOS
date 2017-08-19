//
//  PopStorePointsList.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/8.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderStoreModel.h"
@protocol PopStoreListDelegate <NSObject>
@optional
- (void)didSelectNaviWithStoreModel:(OrderStoreModel*)storeModel;
- (void)didSelectDetailWithStoreModel:(OrderStoreModel*)storeModel;
@end


@interface PopStorePointsList : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak  ) id<PopStoreListDelegate> delegate;
- (void)showPopViewWith:(OrderStoreModel *)model andPopStoreListDelegate:(id<PopStoreListDelegate>)delegate;
- (void)hidden;
@end
