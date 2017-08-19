//
//  CCTimerServer.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/14.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTimerServer : NSObject
+(id)defaultServer;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) NSTimeInterval currentTimeIntervarl;
- (void)getServerTime;
@end
