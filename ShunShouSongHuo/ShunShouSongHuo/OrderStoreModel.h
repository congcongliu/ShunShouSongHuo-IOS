//
//  OrderStoreModel.h
//  AgilePOPs
//
//  Created by CongCong on 2017/7/25.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol OrderStoreModel <NSObject>
@end

@interface OrderStoreModel : JSONModel
@property (nonatomic, copy  ) NSString<Optional> * _id;
@property (nonatomic, copy  ) NSString<Optional> * name;
@property (nonatomic, copy  ) NSString<Optional> * address;
@property (nonatomic, copy  ) NSString<Optional> * contact_phone;
@property (nonatomic, copy  ) NSString<Optional> * contact_name;

@property (nonatomic, strong) NSArray< Optional> * location;
@property (nonatomic, strong) NSArray< Optional> * header_photos;

@property (nonatomic, strong) NSNumber<Optional> * order_count;
@property (nonatomic, strong) NSNumber<Optional> * self_order_count;
@property (nonatomic, strong) NSNumber<Optional> * urgent_order_count;
@end
