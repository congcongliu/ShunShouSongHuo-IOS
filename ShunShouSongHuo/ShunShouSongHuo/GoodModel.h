//
//  GoodModel.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/9.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GoodModel <NSObject>
@end

@interface GoodModel : JSONModel
@property (nonatomic, copy  ) NSString<Optional> * goods_name;
@property (nonatomic, copy  ) NSString<Optional> * goods_spec;
@property (nonatomic, copy  ) NSString<Optional> * goods_category;
@property (nonatomic, copy  ) NSString<Optional> * goods_brand;
@property (nonatomic, copy  ) NSString<Optional> * goods_volume;
@property (nonatomic, copy  ) NSString<Optional> * goods_unit;
@property (nonatomic, copy  ) NSString<Optional> * goods_quantity;
@property (nonatomic, strong) NSNumber<Optional> * price;
@property (nonatomic, strong) NSNumber<Optional> * count;
@property (nonatomic, strong) NSNumber<Optional> * subtotal;

@end
