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
@property (nonatomic, strong) NSMutableArray         *selectedStores;
@property (nonatomic, assign) BOOL                   isRouted;//是否已规划
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<OrderStoreDelegate>)delegate;
- (void)hiddenPopList;
- (void)reloadData;
- (void)showDriveRoute;
- (void)startSelectStore;
- (void)stopSelectStore;
- (void)addStorageAnnotationView;
- (NSInteger)getSeletedCount;
@end
