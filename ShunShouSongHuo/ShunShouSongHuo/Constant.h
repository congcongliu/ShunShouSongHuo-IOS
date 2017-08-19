//
//  Constant.h
//  ShunShouSongHuo
//
//  Created by CongCong on 2017/8/4.
//  Copyright © 2017年 CongCong. All rights reserved.
//


#define APPVERSION @"100000"
#define BASE_URL @"https://zhuzhu1688.com"   //测试服务器
//#define BASE_URL @"http://192.168.3.129:4002"   //本地服务器



#define QN_HEARDER_URL                      @"https://dn-agilepops.qbox.me/"      //七牛头
#define USER_APP_INFO_URL                   @"/user/app_info"                     //获取App端用户任务需要的配置信息.
#define GET_QN_IMAGE_TOKEN                  @"/token/image/upload"                //get 获取token
#define GET_QN_VOICE_TOKEN                  @"/token/media/upload"                //获取voice_token
#define USER_LOGIN_IN                       @"/v2/user/deliveryman_sign_in"       //登陆 post
#define USER_GET_STORE_MAP                  @"/v3/deliveryman/poi_on_map"         //获取map门店 get
#define USER_GET_STORE_LIST                 @"/v3/deliveryman/poi_on_list"        //获取list门店 get
#define USER_GET_STORAGE                    @"/v3/deliveryman/distributor_info"   //获取仓库信息 get
#define USER_GET_STORE_DETAIL               @"/v3/deliveryman/poi_order_infos"    //获取门店详情 get
#define USER_GET_ORDER_DETAIL               @"/v3/deliveryman/order_activity"      //获取订单详情 get
#define USER_GET_GOODS_LIST                 @"/v3/deliveryman/select_pois_order_summary" //装货清单 get
#define USER_CLAIM_ORDER_STORE              @"/v3/deliveryman/claim_poi_orders"    //认领门店 post
#define USER_CONFIRM_DELIVEY                @"/v3/deliveryman/order_arrival"       //确认收货 post
#define USER_UPLOAD_REMARKS                 @"/v3/deliveryman/submit_delivery_info"//递交备注
#define GET_SERVER_TIME                     @"/app/server_time"                   //get 获取服务器时间

#define CORNERRADIUS 6.0f
#define SYSTEM_NAVI_HEIGHT  64.0f
#define SYSTEM_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SYSTEM_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];

#define CCWeakSelf(type)  __weak typeof(type) weak##type = type;
#define CCStrongSelf(type)  __strong typeof(type) type = weak##type;

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#ifdef DEBUG
#define CCLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define CCLog(...)
#endif


#define ACCESS_TOKEN_INVAILD_NOTI              @"access_token_invaild_notification"
#define ORDER_GOODS_DElIVERYED_NOTI            @"order_good_deliveryed_notification"
#define ADD_NEW_PHOTO_UPLOAD_NOTI              @"add_new_photo_upload_notification"
#define ADD_NEW_VOICE_UPLOAD_NOTI              @"add_new_voice_upload_notification"




