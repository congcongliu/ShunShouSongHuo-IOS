//
//  CCTool.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCTool.h"
#import <SSKeychain.h>
#import "CCFile.h"
#import <SystemConfiguration/SystemConfiguration.h>  // 需要事先导入SystemConfiguration.framework
#import <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#import <sys/utsname.h>
#import "GTMBase64.h"
/**
 [""]	<#Description#>判断String是否为空
 [""] */
BOOL isEmpty(NSString* value)
{
    if(!value || [value isEqualToString:@""])
        return YES;
    return NO;
}
/**
 *  Base64编码
 *
 *  @param data 二进制文件
 *
 *  @return 编码结果
 */

NSString* encodeBase64Data(NSData *data)
{
    data = [GTMBase64 encodeData:data];
    //    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
/**
 *  图片压缩
 *
 *  @param img  原图
 *  @param size 压缩大小
 *
 *  @return 压缩图
 */
UIImage *scaleToSize(UIImage *img ,CGSize size)
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


UIImage *newScaleToSize(UIImage*image){
    
    UIImage *newImage = image;
    NSData *imageData = UIImageJPEGRepresentation(image,1);
    
    if (imageData.length<50000) {
        return newImage;
    }else if (imageData.length>1000000){
        CGSize size = CGSizeMake(image.size.width/3, image.size.height/3);
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        // 从当前context中创建一个改变大小后的图片
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片
    }
    //压缩到50000
    
    CGFloat dataKBytes = imageData.length;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > 50000 && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        imageData = UIImageJPEGRepresentation(newImage, maxQuality);
        dataKBytes = imageData.length;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    newImage = [UIImage imageWithData:imageData];
    return newImage;
}



/**
 *  UUID
 *
 *  @return UUID
 */
NSString* myUUID()
{
    //唯一设备标示码
    NSString *NewUUID = [SSKeychain passwordForService:@"com.shunshouzhuanqian.agilepopsTLL" account:@"user"];
    if (NewUUID==nil)
    {
        NSLog(@"没有存储");
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        [SSKeychain setPassword: [NSString stringWithFormat:@"%@", uuidStr]
                     forService:@"com.shunshouzhuanqian.agilepopsTLL" account:@"user"];
        NewUUID = [NSString stringWithFormat:@"%@", uuidStr];
    }
    return NewUUID;
}
/**
 *  countryCode
 *
 *  @return code
 */
NSString *countryCode()
{
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *localCode  = [currentLocale objectForKey:NSLocaleCountryCode];
    NSString *countryCode = [dictCodes objectForKey:localCode];
    if (countryCode==nil) {
        return @"";
    }else{
        return [NSString stringWithFormat:@"+%@",countryCode];
    }
}
/**
 *  currentLoacalLanguage
 *
 *  @return currentLoacalLanguage
 */
NSString* currentLoacalLanguage(){
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage hasPrefix:@"zh"]) {
        return  @"zh_CN";
    }
    else{
        return @"en";
    }
}

/**
 *  字体
 *
 *  @param size 字体大小
 *
 *  @return UIFont
 */
UIFont* fontBysize(float size)
{
    //    return [UIFont fontWithName:@"Helvetica" size:size];
    return [UIFont systemFontOfSize:size];
}





/**
 [""]	<#Description#>是否联网
 [""]	@returns <#return value description#>
 [""] */
BOOL isConnecting()
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

UIApplication* application()
{
    return  [UIApplication sharedApplication];
}

CGRect statusBarFrame()
{
    return [application() statusBarFrame];
}

int statusBarHeight()
{
    CGRect cGRect=statusBarFrame();
    return cGRect.size.height;
}

void callNumber(NSString*number, UIView* view)
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",number];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [view addSubview:callWebview];
}

NSArray *attributeRangesByString(NSString *string)
{
    NSMutableArray *ranges = [NSMutableArray array];
    if (string==nil||[string isEqualToString:@""]) {
        return ranges;
    }
    NSString *newString = string;
    BOOL doAgain = YES;
    do{
        NSRange leftRange = [newString rangeOfString:@"[["];
        NSRange rightRange = [newString rangeOfString:@"]]"];
        if (leftRange.location!=NSNotFound&&rightRange.location!=NSNotFound) {
            NSRange textRange = NSMakeRange(leftRange.location, rightRange.location-leftRange.location-2);
            newString = [newString stringByReplacingCharactersInRange:rightRange withString:@""];
            newString = [newString stringByReplacingCharactersInRange:leftRange withString:@""];
            [ranges addObject:[NSValue valueWithRange:textRange]];
        }else{
            doAgain = NO;
        }
        
    }while(doAgain);
    
    return ranges;
}

NSMutableAttributedString *bigRedAttributeByString(NSString *string,UIFont *baseFont)
{
    NSString *resultString = [string stringByReplacingOccurrencesOfString:@"[[" withString:@""];
    
    resultString = [resultString stringByReplacingOccurrencesOfString:@"]]" withString:@""];
    
    
    
    NSDictionary *fontDic = [NSDictionary dictionaryWithObject:baseFont forKey:NSFontAttributeName];
    NSMutableAttributedString *resultAttrString = [[NSMutableAttributedString alloc]initWithString:resultString attributes:fontDic];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:4];
    [resultAttrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, resultString.length)];
    
    if (resultAttrString == nil || resultAttrString.length==0) {
        return resultAttrString;
    }
    
    NSString *newString = string;
    BOOL doAgain = YES;
    do{
        NSRange leftRange = [newString rangeOfString:@"[["];
        NSRange rightRange = [newString rangeOfString:@"]]"];
        if (leftRange.location!=NSNotFound&&rightRange.location!=NSNotFound&&leftRange.location<rightRange.location) {
            NSRange textRange = NSMakeRange(leftRange.location, rightRange.location-leftRange.location-2);
        
            if ((textRange.location+textRange.length)<=newString.length&&(textRange.location+textRange.length)<=resultAttrString.length) {
                
                newString = [newString stringByReplacingCharactersInRange:rightRange withString:@""];
                newString = [newString stringByReplacingCharactersInRange:leftRange withString:@""];
                
                [resultAttrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:textRange];
                [resultAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:textRange];
            }else{
                doAgain = NO;
            }
        }else{
            doAgain = NO;
        }
        
    }while(doAgain);
    return resultAttrString;
}

NSString* systemDevice(){
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

UIImage* addLocalPhoto(NSString *name){
    if (name == nil) {
        return nil;
    }
#pragma mark --------> 缩略图
    NSString* filePath = filePathByName([NSString stringWithFormat:@"%@.jpg",name]);
    NSData* imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}



