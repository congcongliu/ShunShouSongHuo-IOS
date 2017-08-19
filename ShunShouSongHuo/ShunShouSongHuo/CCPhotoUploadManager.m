//
//  CCPhotoUploadManager.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/12.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CCPhotoUploadManager.h"
#import "CCFile.h"
#import "Constant.h"
#import "CCDBManager.h"
#import "CCHTTPRequest.h"
#import "NSString+Tool.h"
#import <QNResponseInfo.h>
#import <QNUploadManager.h>
#import "JDStatusBarNotification.h"

@interface CCPhotoUploadManager (){
    BOOL _isUploading;
    NSString *_qnToken;
    CCDBManager *_dbManager;
    dispatch_queue_t _serialQueue;
    QNUploadManager* _qnUploadManager;
}

@end

@implementation CCPhotoUploadManager
+ (instancetype)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUpload];
    }
    return self;
}

- (void)initUpload{
    _dbManager = [CCDBManager sharedManager];
    _qnUploadManager = [[QNUploadManager alloc] init];
    _serialQueue = dispatch_queue_create("myThreadQueueImageUpload", DISPATCH_QUEUE_SERIAL);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUploadPhoto) name:ADD_NEW_PHOTO_UPLOAD_NOTI object:nil];
}

- (void)startUploadPhoto{
    _qnToken = qn_token();
    if (!_qnToken||[_qnToken isEmpty]) {
        [self getQntoken];
        return;
    }
    NSArray *photos = [_dbManager getAllUnuploadPhotos];
    if (photos.count == 0) {
        [self uploadSucceed];
    }else if(!_isUploading){
        _isUploading = YES;
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"li_you_have_file_upload", nil) styleName:JDStatusBarStyleWarning];
        [self uploadPhotoWithFileName:photos[0]];
    }
}

- (void)startUploadPhotoAnagin{
    
    if (!_qnToken || [_qnToken isEmpty]) {
        _isUploading = NO;
        [self getQntoken];
        return;
    }
    
    NSArray *photos = [_dbManager getAllUnuploadPhotos];
    CCLog(@"----------->还剩%ld张照片",photos.count);
    if (photos.count == 0) {
        [self uploadSucceed];
    }else{
        [self uploadPhotoWithFileName:photos[0]];
    }
}

- (void)uploadSucceed{
    _isUploading = NO;
    if (![_dbManager hasUploadFile]) {
        [JDStatusBarNotification dismiss];
    }
}

- (void)uploadPhotoWithFileName:(NSString *)fileName{
    NSString *filePath = filePathByName([NSString stringWithFormat:@"%@.jpg", fileName]);
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    if (imageData.length<1) {
        [_dbManager deletePhotoWithFileName:fileName];
        [self startUploadPhotoAnagin];
        return;
    }
    dispatch_async(_serialQueue, ^{
        NSLog(@"fileName:%@ \n token:%@",filePath,_qnToken);
        [_qnUploadManager putFile:filePath key:fileName token:_qnToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.isOK) {
                [_dbManager photoUplaodSuccedWithFileName:fileName];
            }else if (info.statusCode == 401||info.statusCode == kQNInvalidToken){
                _qnToken = nil;
            }else{
                CCLog(@"%@", info.error.localizedDescription);
                [_dbManager deletePhotoWithFileName:fileName];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
              [self startUploadPhotoAnagin];
            });
        } option:nil];
    });
}

- (void)getQntoken{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:accessToken() forKey:ACCESS_TOKEN];
    CCWeakSelf(self);
    [[CCHTTPRequest requestManager] getWithRequestBodyString:GET_QN_IMAGE_TOKEN parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            [weakself performSelector:@selector(startUploadPhoto) withObject:nil afterDelay:15];
        }else{
            NSString *token = [result objectForKey:@"token"];
            _qnToken = nil;
            NSLog(@"%@",token);
            save_qntoken(token);
            [weakself startUploadPhoto];
        }
    }];
}

@end
