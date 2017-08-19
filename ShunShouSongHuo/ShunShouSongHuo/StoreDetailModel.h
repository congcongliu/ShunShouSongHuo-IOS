//
//  StoreDetailModel.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/9.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ActivityModel.h"
#import "OrderStoreModel.h"
@interface StoreDetailModel : JSONModel
@property (nonatomic, strong) OrderStoreModel< Optional > *poi;
@property (nonatomic, strong) NSMutableArray < Optional, ActivityModel > *activities;
@end
