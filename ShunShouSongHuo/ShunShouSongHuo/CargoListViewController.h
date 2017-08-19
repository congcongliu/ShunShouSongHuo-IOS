//
//  CargoListViewController.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/8.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CargoListCallBack)(BOOL isSucceed);

@interface CargoListViewController : BaseViewController
- (instancetype)initWithSelectStoreCount:(NSInteger)storeCount;
- (instancetype)initWithSelectStoreIds:(NSArray *)storeIds andCallback:(CargoListCallBack)callback;

@end
