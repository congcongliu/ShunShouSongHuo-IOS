//
//  UserLocation.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/5/16.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface UserLocation : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D userLoaction;
@property (nonatomic, copy  ) NSString               *addressCode;
@property (nonatomic, copy  ) NSString               *provinceName;
@property (nonatomic, copy  ) NSString               *cityName;
@property (nonatomic, copy  ) NSString               *districtName;
@property (nonatomic, copy  ) NSString               *township;
+ (id)defaultUserLoaction;
- (void)getLoaction;
- (void)clearLocation;
- (CLLocationCoordinate2D)getUserCoordinate;
@end
