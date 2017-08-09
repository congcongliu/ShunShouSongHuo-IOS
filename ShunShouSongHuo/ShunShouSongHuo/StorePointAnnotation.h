//
//  StorePointAnnotation.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/8.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "OrderStoreModel.h"
@interface StorePointAnnotation : MAPointAnnotation
@property (nonatomic, strong) OrderStoreModel *storeModel;
@end
