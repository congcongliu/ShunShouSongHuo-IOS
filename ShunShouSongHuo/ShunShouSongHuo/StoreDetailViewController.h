//
//  StoreDetailViewController.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/9.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderStoreModel.h"
@interface StoreDetailViewController : BaseViewController
- (instancetype)initWithStoreModel:(OrderStoreModel*)storeModel;
@end
