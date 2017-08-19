//
//  CCDBManager.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/12.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDBManager : NSObject
+ (instancetype)sharedManager;
- (void)insertPhotoWithfileName:(NSString *)fileName;
- (void)insertPhotosWithfileNames:(NSArray *)fileNames;
- (NSArray *)getAllUnuploadPhotos;
- (void)deleteAllPhotos;
- (void)deletePhotoWithFileName:(NSString *)fileName;
- (void)photoUplaodSuccedWithFileName:(NSString *)fileName;


- (void)insertVoiceWithFileName:(NSString *)fileName;
- (void)deleteVoiceFileWithFileName:(NSString *)fileName;
- (void)voiceUploadSucceedWithFileName:(NSString *)fileName;
- (NSMutableArray *)getAllUnuploadVoices;
- (void)deleteAllVoices;


- (BOOL)hasUploadFile;

@end
