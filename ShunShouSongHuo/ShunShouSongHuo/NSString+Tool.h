//
//  NSString+Tool.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)
-(BOOL) isEmpty;
-(BOOL) isEqualToLowerString:(NSString *)aString;
-(float)sizeW:(int)fontSize;
-(float)sizeH:(int)fontSize withLabelWidth:(float)width;
-(NSString*)format:(NSString*)format;
-(NSDate *)dateFromString;
-(BOOL) isValidateDecimals;
-(BOOL) isValidateEge;
-(BOOL) isValidateMobile;
-(BOOL) validateCarNo;
-(BOOL) isValidateDate;
-(NSDate*)getDateByFormat:(NSString *)format;
-(NSInteger)getTimeIntervalByFormat:(NSString *)format;
-(NSMutableDictionary *)JSONDataDictionary;

@end
