//
//  ActivityModel.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/9.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GoodModel.h"
#import "SignatureModel.h"

@protocol ActivityModel <NSObject>
@end

@interface ActivityModel : JSONModel
@property (nonatomic, copy  ) NSString<Optional> * _id;
@property (nonatomic, copy  ) NSString<Optional> * submit_time;
@property (nonatomic, copy  ) NSString<Optional> * order_deliveryman;
@property (nonatomic, strong) NSNumber<Optional> * order_total_price;
@property (nonatomic, strong) SignatureModel< Optional > *order_signature;
@property (nonatomic, strong) NSMutableArray < Optional, GoodModel > *goods;
@end
