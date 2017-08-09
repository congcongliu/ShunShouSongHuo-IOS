//
//  UserLocation.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/5/16.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "UserLocation.h"
#import "CCTool.h"
#import "NSString+Tool.h"
#import "CCHTTPRequest.h"
#import "NSMutableDictionary+Tool.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface UserLocation ()<AMapLocationManagerDelegate,AMapSearchDelegate>{
    NSTimer *_timer;
    AMapSearchAPI *_search;
}
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) NSInteger            totalCount;
@end

@implementation UserLocation
+(id)defaultUserLoaction{
    
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 50.00;
        //初始化检索对象
        save_uploadLocation(NO);
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [self getLoaction];
        
//        _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(getLoaction) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)clearLocation{
    self.addressCode = @"";
    self.provinceName = @"";
    self.cityName = @"";
    self.districtName = @"";
}
- (NSString *)addressCode{
    if ([_addressCode isEmpty]||!_addressCode) {
        return @"";
    }
    else{
        return _addressCode;
    }
}
- (NSString *)provinceName{
    if ([_provinceName isEmpty]||!_provinceName) {
        return @"";
    }
    else{
        return _provinceName;
    }
}
- (NSString *)cityName{
    if ([_cityName isEmpty]||!_cityName) {
        return @"";
    }
    else{
        return _cityName;
    }
}
- (NSString *)districtName{
    if ([_districtName isEmpty]||!_districtName) {
        return @"";
    }
    else{
        return _districtName;
    }
}

- (NSString *)township{
    if ([_township isEmpty]||!_township) {
        return @"";
    }
    else{
        return [NSString stringWithFormat:@"%@%@",_districtName,_township];
    }
}

- (void)getLoaction{
    [self.locationManager startUpdatingLocation];
}

- (CLLocationCoordinate2D)userLoaction{
    return _userLoaction;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    NSLog(@"userLocation===>:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.userLoaction = location.coordinate;
    if (!_addressCode||[_addressCode isEmpty]||!_cityName||[_cityName isEmpty]) {
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude     longitude:location.coordinate.longitude];
        regeo.radius = 10000;
        regeo.requireExtension = YES;
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeo];
    }else{
        [self.locationManager stopUpdatingLocation];
    }
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSString *city = response.regeocode.addressComponent.city;
        if (!city||[city isEmpty]) {
            city = response.regeocode.addressComponent.province;
        }
        NSLog(@"%@",city);
        self.cityName = city;
        self.provinceName = response.regeocode.addressComponent.province;
        self.addressCode = response.regeocode.addressComponent.adcode;
        self.districtName = response.regeocode.addressComponent.district;
        self.township = response.regeocode.addressComponent.township;
        [self.locationManager stopUpdatingLocation];
    }
}
//- (void)userUploadLocation{
//    
//    if (user_uploadLocation()||[accessToken() isEmpty]) {
//        return;
//    }
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    double lat = _userLoaction.latitude;
//    double lon = _userLoaction.longitude;
//    
//    [parameters put:@[[NSNumber numberWithDouble:lon],[NSNumber numberWithDouble:lat]] key:@"location"];
//    [parameters put:self.addressCode key:@"adcode"];
//    [parameters put:self.provinceName key:@"province_name"];
//    [parameters put:self.cityName key:@"city_name"];
//    [parameters put:self.districtName key:@"district_name"];
//    [parameters put:accessToken() key:@"access_token"];
//    
//    
//    [[CCHTTPRequest requestManager] postWithRequestBodyString:USER_UPDATE_LOCATION parameters:parameters resultBlock:^(NSDictionary *result, NSError *error) {
//        if (!error) {
//            save_uploadLocation(YES);
//            NSLog(@"------------------------->上传用户位置信息");
//        }
//    }];
//    
//    NSMutableDictionary *deviceParameters = [NSMutableDictionary dictionary];
//    NSString *vision = [UIDevice currentDevice].systemVersion;
//    [deviceParameters put:vision key:@"mobile_soft_release"];
//    [deviceParameters put:@"Apple" key:@"mobile_manufacturer"];
//    [deviceParameters put:systemDevice() key:@"mobile_model"];
//    [deviceParameters put:accessToken() key:@"access_token"];
//    
//    [[CCHTTPRequest requestManager] postWithRequestBodyString:USER_UPDATE_MOBILE_DEVICE_INFO parameters:deviceParameters resultBlock:^(NSDictionary *result, NSError *error) {
//        if (!error) {
//            NSLog(@"------------------------->上传用户手机信息");
//        }
//    }];
//    
//}

- (void)applicationWillBecomeActive{
    [self getLoaction];
}

- (void)applicationEnterBackground{
    [_timer invalidate];
    [_timer fire];
    _timer = nil;
}
- (CLLocationCoordinate2D)getUserCoordinate{
    return self.userLoaction;
}
@end
