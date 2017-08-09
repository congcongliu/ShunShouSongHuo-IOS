//
//  NSString+Tool.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "NSString+Tool.h"
#import "CCTool.h"
#import <UIKit/UIKit.h>
@implementation NSString (Tool)
-(BOOL) isEmpty
{
    if(!self || [self isEqualToString:@""]||self == nil)
        return YES;
    return NO;
}

-(BOOL) isEqualToLowerString:(NSString *)aString
{
    if([self isEqualToString:[aString lowercaseString]])
        return YES;
    return NO;
}

-(float)sizeW:(int)fontSize
{
    CGSize sizeName = [self sizeWithFont:fontBysize(fontSize)
                       constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                           lineBreakMode:NSLineBreakByCharWrapping];
    return sizeName.width+1;
}

-(float)sizeH:(int)fontSize withLabelWidth:(float)width
{
    CGSize sizeName = [self sizeWithFont:fontBysize(fontSize)
                       constrainedToSize:CGSizeMake(width, MAXFLOAT)
                           lineBreakMode:NSLineBreakByCharWrapping];
    
    return sizeName.height;
}

-(NSString*)format:(NSString*)format{
    if ([format isEmpty]) {
        return @"";
    }
    NSDate *date = [self dateFromString];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:format];
    NSString *timeSting = [formatter stringFromDate:date];
    return timeSting;
}


-(BOOL)isValidateDecimals
{
    NSString *decimalsRegex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    NSPredicate *decimalsTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",decimalsRegex];
    if ([self isEqualToString:@""]) {
        return YES;
    }
    return [decimalsTest evaluateWithObject:self];
}

- (NSDate *)dateFromString{
    if ([self isEmpty]) {
        return nil;
    }
    struct tm tm;
    time_t t;
    strptime([self cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];
    return date;
}

-(NSMutableDictionary *)JSONDataDictionary{
    
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization
                                JSONObjectWithData:jsonData
                                options:NSJSONReadingMutableContainers
                                error:&err];
    if(err) {
        NSLog(@"json解析失败:%@",err);
        return nil;
    }
    return dic;
}
-(BOOL)isValidateEge
{
    NSString *emailRegex = @"^(?:[1-9][0-9]?|1[01][0-9]|120)$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (self.intValue>99) {
        return NO;
    }
    return [emailTest evaluateWithObject:self];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:self];
}

/*车牌号验证 MODIFIED BY HELENSONG*/
-(BOOL)validateCarNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}

/*日期验证*/
-(BOOL)isValidateDate
{

    NSString *timeString;
    
    if (self.length>6) {
        return NO;
    }
    
    if (self.length==5&&self.integerValue%10!=0) {
        timeString = @"20000100";
    }else{
        timeString = @"20000101";
    }
    
    timeString = [timeString stringByReplacingCharactersInRange:NSMakeRange(2, self.length) withString:self];
    
    NSString *dateRegex = @"(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))0229)";
    NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",dateRegex];
//    NSLog(@"carTest is %@",dateTest);
    return [dateTest evaluateWithObject:timeString];
}




-(NSDate*)getDateByFormat:(NSString *)format{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:format];
    NSDate *willdate = [formate dateFromString:self];
    return willdate;
}

- (NSInteger)getTimeIntervalByFormat:(NSString *)format{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:format];
    NSDate *willdate = [formate dateFromString:self];
    return willdate.timeIntervalSince1970*1000;
}

@end
