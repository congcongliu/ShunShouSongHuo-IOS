//
//  CCFile.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
BOOL isFileExist(NSString* path);
void creatPath(NSString* path);
NSString* filePathByName(NSString* fileName);
BOOL saveImg(UIImage* img,NSString* fileName);
BOOL saveOrginImg(NSData* imgData,NSString* fileName);
