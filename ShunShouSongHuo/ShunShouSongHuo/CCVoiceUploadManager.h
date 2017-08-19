//
//  CCVoiceUploadManager.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCVoiceUploadManager : NSObject
+ (instancetype)sharedManager;
- (void)startUploadVoice;

@end
