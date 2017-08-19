//
//  OrderDetailViewController.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/10.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "BaseViewController.h"
#import "ActivityModel.h"
@interface OrderDetailViewController : BaseViewController
@property (nonatomic, copy  ) NSString       *storeId;
@property (nonatomic, assign) NSInteger      activityCount;
- (instancetype)initWithActivityModel:(ActivityModel*)activityModel isCheckOrder:(BOOL)isCheckOrder;
@end
