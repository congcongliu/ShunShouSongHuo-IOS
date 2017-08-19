//
//  TakePhotosObjectModel.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/8/14.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol TakePhotosObjectModel <NSObject>

@end

@interface TakePhotosObjectModel : JSONModel
@property (nonatomic, copy  ) NSString<Optional > * key;
@property (nonatomic, strong) NSNumber<Optional > * time_stamp;
@end
