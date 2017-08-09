//
//  OrderStoreListView.h
//  AgilePOPs
//
//  Created by CongCong on 2017/7/21.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderStoreModel.h"
typedef void(^OrderStoreListSeletedCallBack)(OrderStoreModel *storeModel);
@interface OrderStoreListView : UIView
- (void)reloadData;
- (void)tableRefesh;
- (instancetype)initTokenStoreListWithFrame:(CGRect)frame andSeletedCallBack:(OrderStoreListSeletedCallBack)callBack;
- (instancetype)initVaildStoreListWithFrame:(CGRect)frame andSeletedCallBack:(OrderStoreListSeletedCallBack)callBack;
@end
