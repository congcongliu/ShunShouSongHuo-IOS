//
//  RecordVoiceModel.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/15.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RecordVoiceModel : JSONModel
@property (nonatomic, copy  ) NSString<Optional > * key;
@property (nonatomic, strong) NSNumber<Optional > * time_stamp;
@property (nonatomic, assign) NSNumber<Optional > * file_size;
@end
