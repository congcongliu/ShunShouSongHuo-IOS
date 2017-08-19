//
//  CCVoiceUploadManager.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CCVoiceUploadManager.h"
#import "CCFile.h"
#import "Constant.h"
#import "CCDBManager.h"
#import "CCHTTPRequest.h"
#import "NSString+Tool.h"
#import <QNResponseInfo.h>
#import <QNUploadManager.h>
#import "JDStatusBarNotification.h"
#import "NSMutableDictionary+Tool.h"
@interface CCVoiceUploadManager (){
    BOOL _isUploading;
    CCDBManager *_dbManager;
    dispatch_queue_t _serialQueue;
    QNUploadManager* _qnUploadManager;
}

@end

@implementation CCVoiceUploadManager

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
    _serialQueue = dispatch_queue_create("myThreadQueueVoiceUpload", DISPATCH_QUEUE_SERIAL);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUploadVoice) name:ADD_NEW_VOICE_UPLOAD_NOTI object:nil];
}

- (void)startUploadVoice{
    NSArray *voices = [_dbManager getAllUnuploadVoices];
    if (voices.count == 0) {
        [self uploadSucceed];
    }else if(!_isUploading){
        _isUploading = YES;
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"li_you_have_file_upload", nil) styleName:JDStatusBarStyleWarning];
        [self getVoiceToken:voices[0]];
    }
}

- (void)startUpladVoiceAgain{
    NSArray *voices = [_dbManager getAllUnuploadVoices];
    CCLog(@"---------------->录音还剩%ld条",voices.count);
    if (voices.count == 0) {
        [self uploadSucceed];
    }else{
        [self getVoiceToken:voices[0]];
    }
}

- (void)uploadSucceed{
    _isUploading = NO;
    if (![_dbManager hasUploadFile]) {
        [JDStatusBarNotification dismiss];
    }
}

- (void)getVoiceToken:(NSString *)fileName{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters put:accessToken() key:ACCESS_TOKEN];
    [parameters put:fileName key:@"mp3_key"];
    [[CCHTTPRequest requestManager] getWithRequestBodyString:GET_QN_VOICE_TOKEN parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            CCLog(@"err%@",error.localizedDescription);
            
        }
        else{
            NSString *token = [result objectForKey:@"token"];
            [self uploadVoiceWithFileName:fileName andQnToken:token];
        }
    }];
}

- (void)uploadVoiceWithFileName:(NSString *)fileName andQnToken:(NSString *)token{
    if (!token||[token isEmpty]) {
        [self performSelector:@selector(startUpladVoiceAgain) withObject:nil afterDelay:5];
        return;
    }
    
    dispatch_async(_serialQueue, ^{
        CCLog(@"%@",fileName);
        CCLog(@"path%@",filePathByName(fileName));
        [_qnUploadManager putFile:filePathByName(fileName) key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.isOK) {
                [_dbManager voiceUploadSucceedWithFileName:fileName];
                [self startUpladVoiceAgain];
            }else if (info.statusCode == 401||info.statusCode == kQNInvalidToken){
                [self performSelector:@selector(startUpladVoiceAgain) withObject:nil afterDelay:5];
            }else{
                [_dbManager deleteVoiceFileWithFileName:fileName];
                [self startUpladVoiceAgain];
            }
            
        } option:nil];
    });
}


@end
