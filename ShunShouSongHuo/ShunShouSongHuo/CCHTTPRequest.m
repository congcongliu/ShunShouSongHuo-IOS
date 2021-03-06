//
//  CCHTTPRequest.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//
#define CustomErrorDomain @"没有网络"

#import "CCHTTPRequest.h"
#import "CCTool.h"
#import "CCAlert.h"
#import "NSString+Tool.h"
#import "NSDictionary+Tool.h"
#import <AFURLSessionManager.h>
#import <AFHTTPSessionManager.h>
@interface CCHTTPRequest (){
    AFNetworkReachabilityStatus netWorkStatus;
}
@end

@implementation CCHTTPRequest

+(instancetype)requestManager
{
    static id requestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[self alloc] init];
        
    });
    return requestManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self listenNetWokingStatus];
    }
    return self;
}

- (void)getWithRequestBodyString:(NSString *)header
                parameters:(id)parameters
               resultBlock:(void (^)(NSDictionary *result,NSError *error))resultBlock
{
    if (!isConnecting()) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"can not connect netwoking"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *customError = [[NSError alloc]initWithDomain:CustomErrorDomain code:-404 userInfo:userInfo];
        if (resultBlock) {
            return resultBlock(nil,customError);
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 30;

    NSString *URL = [self requestUrl:header];
    
    NSLog(@"GET--URL:%@   \n paraters:%@",URL,parameters);
    
    [manager GET:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"GET --> %@, \n Callback Thread%@", URL, [NSThread currentThread]); //自动返回主线程
        if (resultBlock) {
            NSDictionary *result = (NSDictionary*)responseObject;
            NSError *error;
            if ([result hasKey:@"err"]) {
                NSDictionary *errDict = [result objectForKey:@"err"];
                NSString *errType = [errDict stringForKey:@"type"];
                error = [[NSError alloc]initWithDomain:errType code:-200 userInfo:errDict];
                
                if ([error.domain isEqualToString:@"invalid_access_token"]||[error.domain isEqualToString:@"undefined_access_token"]||[error.domain isEqualToString:@"user_not_deliveryman"]) {
                    save_AccessToken(@"");
                    [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_INVAILD_NOTI object:nil];
                }
                
            }
            resultBlock(result,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"can not connect netwoking"                                                                      forKey:NSLocalizedDescriptionKey];
            error = [[NSError alloc]initWithDomain:error.localizedDescription code:-404 userInfo:userInfo];
        }
        if (resultBlock) {
            resultBlock(nil,error);
        }
    }];
}

- (void)postWithRequestBodyString:(NSString *)header
                 parameters:(id)parameters
                resultBlock:(void (^)(NSDictionary *result,NSError *error))resultBlock
{
    if (!isConnecting()) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"can not connect netwoking"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *customError = [[NSError alloc]initWithDomain:CustomErrorDomain code:-404 userInfo:userInfo];
        if (resultBlock) {
            return resultBlock(nil,customError);
        }
    }    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    /**
     *  请求队列的最大并发数
     */
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 30;
    
    NSString *URL = [self requestUrl:header];
    NSLog(@"POST--URL:%@\n paraters:%@",URL,parameters);
    
    [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"POST --> %@, \n Callback Thread%@", URL, [NSThread currentThread]); //自动返回主线
        if (resultBlock) {
            NSDictionary *result = (NSDictionary*)responseObject;
            NSError *error;
            if ([result hasKey:@"err"]) {
                NSDictionary *errDict = [result objectForKey:@"err"];
                NSString *errType = [errDict stringForKey:@"type"];
                
                error = [[NSError alloc]initWithDomain:errType code:-200 userInfo:errDict];
                if ([error.domain isEqualToString:@"invalid_access_token"]||[error.domain isEqualToString:@"undefined_access_token"]||[error.domain isEqualToString:@"user_not_deliveryman"]) {
                    save_AccessToken(@"");
                    [[NSNotificationCenter defaultCenter] postNotificationName:ACCESS_TOKEN_INVAILD_NOTI object:nil];
                }
            }
            resultBlock(result,error);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@", error.localizedDescription);
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"can not connect netwoking"                                                                      forKey:NSLocalizedDescriptionKey];
            error = [[NSError alloc]initWithDomain:error.localizedDescription code:-404 userInfo:userInfo];
        }
        if (resultBlock) {
            resultBlock(nil,error);
        }
    }];
}
/**
 *  选用
 */
- (void)listenNetWokingStatus{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                //toast_showInfoMsg(@"断网了,请检查网络.", 200);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
                //toast_showInfoMsg(@"3G|4G!", 200);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                //toast_showInfoMsg(@"WiFi!", 200);
                break;
            default:
                break;
        }
        self.status = status;
    }];
}

#if DEBUG
- (NSString *)requestUrl:(NSString *)bodyString
{
    NSString * serverAddress = user_diyUrl();
    if (!serverAddress || [serverAddress isEmpty]) {
        serverAddress = BASE_URL;
        save_userDiyUrl(serverAddress);
    }
    return [NSString stringWithFormat:@"%@%@",serverAddress,bodyString];
}
#else
- (NSString *)requestUrl:(NSString *)bodyString
{
    return [NSString stringWithFormat:@"%@%@",BASE_URL,bodyString];
}
#endif

@end
