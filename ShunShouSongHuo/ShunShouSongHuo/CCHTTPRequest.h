//
//  CCHTTPRequest.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/6.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "CCUserData.h"
#import <AFNetworking.h>

@interface CCHTTPRequest: NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus status;
/**
 *  网络请求单例
 *
 *  @return requestManager
 */
+(instancetype)requestManager;
/**
 *  发送get请求
 *
 *  @param header  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param resultBlock    请求的回调
 */
- (void)getWithRequestBodyString:(NSString *)header
                      parameters:(id)parameters
                     resultBlock:(void (^)(NSDictionary *result,NSError *error))resultBlock;

/**
 *  发送get请求
 *
 *  @param header  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param resultBlock    请求的回调
 */

- (void)postWithRequestBodyString:(NSString *)header
                       parameters:(id)parameters
                      resultBlock:(void (^)(NSDictionary *result,NSError *error))resultBlock;

@end
