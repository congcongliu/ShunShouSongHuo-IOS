//
//  CCTool.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//BOOL isEmpty(NSString* value);
NSString* encodeBase64Data(NSData *data);
UIImage *scaleToSize(UIImage *img ,CGSize size);
UIImage *newScaleToSize(UIImage*image);
NSString* myUUID();
NSString* countryCode();
NSString* currentLoacalLanguage();
NSString* systemDevice();
UIFont* fontBysize(float size);
int statusBarHeight();
BOOL isConnecting();
void callNumber(NSString*number, UIView* view);
NSArray *attributeRangesByString(NSString *string);
NSMutableAttributedString *bigRedAttributeByString(NSString *string,UIFont *baseFont);
UIImage* addLocalPhoto(NSString *name);
