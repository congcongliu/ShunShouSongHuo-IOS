//
//  CCPhotoUploadManager.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/12.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCPhotoUploadManager : NSObject
+ (instancetype)sharedManager;
- (void)startUploadPhoto;
@end
