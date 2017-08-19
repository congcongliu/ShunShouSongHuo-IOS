//
//  CCCameraViewController.h
//  AgilePOPs
//
//  Created by CongCong on 2017/5/19.
//  Copyright © 2017年 CongCong. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^CameraPhotoCallBack)(NSString *photoName);

@interface CCCameraViewController : BaseViewController
- (instancetype)initWithPhotoCallBack:(CameraPhotoCallBack)photoCallBack withCurrentPhotoCount:(NSInteger)currentCount requiredPhotoCount:(NSInteger)requireCount andMaxPhotoCount:(NSInteger)maxCount;
@end
