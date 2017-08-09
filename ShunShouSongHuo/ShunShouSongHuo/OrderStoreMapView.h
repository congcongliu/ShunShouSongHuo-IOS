//
//  OrderStoreMapView.h
//  AgilePOPs
//
//  Created by CongCong on 2017/7/21.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderStoreModel.h"

@protocol OrderStoreDelegate <NSObject>
@optional
- (void)didSeletedStore:(OrderStoreModel *)storeModel;
- (void)didDeseletedStore;
- (void)gotoStoreNavi:(OrderStoreModel *)storeModel;
@end

@interface OrderStoreMapView : UIView
@property (nonatomic, weak) id<OrderStoreDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<OrderStoreDelegate>)delegate;
- (void)hiddenPopList;
- (void)reloadData;
- (void)showDriveRoute;
- (void)startSelectStore;
- (void)stopSelectStore;
@end
