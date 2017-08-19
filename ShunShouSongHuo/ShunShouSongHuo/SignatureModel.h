//
//  SignatureModel.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/9.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SignatureModel <NSObject>
@end

@interface SignatureModel : JSONModel
@property (nonatomic, copy  ) NSString<Optional > * key;
@property (nonatomic, copy  ) NSString<Optional > * time;
@property (nonatomic, strong) NSNumber<Optional > * time_stamp;
@end
