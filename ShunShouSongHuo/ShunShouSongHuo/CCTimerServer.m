//
//  CCTimerServer.m
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "CCTimerServer.h"
#import "Constant.h"
#import "CCHTTPRequest.h"
#import "NSString+Tool.h"
#import "NSDictionary+Tool.h"
@interface CCTimerServer (){
    NSTimer *_getNewCurrentTimer;//每1分钟更新一次时间每5分钟取一次时间
    NSTimer *_StopRunTimer;//进入后台超过3分钟停止运行清空时间
    NSInteger _updateTimerCount;//超过5取一次时间
    BOOL _isLoading;
}

@end

@implementation CCTimerServer

+(id)defaultServer{
    static id defaultServer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultServer = [[self alloc] init];
    });
    return defaultServer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _updateTimerCount = 0;
        _currentTimeIntervarl = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [self getServerTime];
        _getNewCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCurrentDate) userInfo:nil repeats:YES];
    }
    return self;
}



- (NSTimeInterval)currentTimeIntervarl{
    if (_currentTimeIntervarl<NSTimeIntervalSince1970) {
        [self getServerTime];
        return [[NSDate date] timeIntervalSince1970];
    }
    return _currentTimeIntervarl;
}

- (void)updateCurrentDate{
    
    if (_currentTimeIntervarl<NSTimeIntervalSince1970) {//978307200
        [self getServerTime];
        return;
    }
    _updateTimerCount++;
    if (_updateTimerCount>=300&&!_isLoading) {
        [self getServerTime];
    }else{
        _currentTimeIntervarl += 1;
        _currentDate = [[NSDate alloc]initWithTimeIntervalSince1970:_currentTimeIntervarl];
        //        NSLog(@"TimeInterval------------>:%@",[self dateStringWith:_currentDate]);
    }
}


- (NSString *)dateStringWith:(NSDate*)date{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式 2016-08-10T09:44:01.606Z
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS Z"];
    //用[NSDate date]可以获取系统当前时间
    return [dateFormatter stringFromDate:date];
}

- (void)getServerTime{
    
    if (!accessToken()||[accessToken() isEmpty]||_isLoading) {
        return;
    }
    
    _isLoading = YES;
    [[CCHTTPRequest requestManager] getWithRequestBodyString:GET_SERVER_TIME parameters:nil resultBlock:^(NSDictionary *result, NSError *error) {
        if (error) {
            NSLog(@"获取网络时间失败");
        }else{
            NSLog(@"servertime:------->%@",result);
            _currentTimeIntervarl = [result doubleForKey:@"time_stamp"]/1000;
            _updateTimerCount = 0;
        }
        _isLoading = NO;
    }];
}

- (void)applicationWillBecomeActive{
    [_StopRunTimer invalidate];
    if (![_getNewCurrentTimer isValid]) {
        [self getServerTime];
        _getNewCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCurrentDate) userInfo:nil repeats:YES];
    }
}

- (void)applicationEnterBackground{
    _StopRunTimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(appNotRun) userInfo:nil repeats:NO];
}

- (void)appNotRun{
    [_getNewCurrentTimer invalidate];
    [_StopRunTimer invalidate];
    _currentTimeIntervarl = 0;
    _updateTimerCount = 0;
}

@end
