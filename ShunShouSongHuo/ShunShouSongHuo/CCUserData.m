//
//  CCUserData.m
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import "CCUserData.h"
NSUserDefaults* userDefaults;

void getUserDefaults()
{
    if(userDefaults==nil)
        userDefaults=[NSUserDefaults standardUserDefaults];
}
/**
 <#Description#> 保存String
 @param key <#key description#>
 @param value <#value description#>
 */

void saveString(NSString* key,NSString* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

/**
 <#Description#> 保存Bool
 @param key <#key description#>
 @param value <#value description#>
 */
void saveBool(NSString* key,BOOL value)
{
    getUserDefaults();
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

/**
 <#Description#>保存Integer
 @param key <#key description#>
 @param value <#value description#>
 */
void saveInteger(NSString* key,int value)
{
    getUserDefaults();
    [userDefaults setInteger:value forKey:key];
    [userDefaults synchronize];
}

/**
 <#Description#>保存Float
 @param key <#key description#>
 @param value <#value description#>
 */
void saveFloat(NSString* key,float value)
{
    getUserDefaults();
    [userDefaults setFloat:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存Double
 @param key <#key description#>
 @param value <#value description#>
 */
void saveDouble(NSString* key,double value)
{
    getUserDefaults();
    [userDefaults setDouble:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存Date
 @param key <#key description#>
 @param value <#value description#>
 */
void saveDate(NSString* key,NSDate* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存Array
 @param key <#key description#>
 @param value <#value description#>
 */
void saveArray(NSString* key,NSArray* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存Dictionary
 @param key <#key description#>
 @param value <#value description#>
 */
void saveDictionary(NSString* key,NSDictionary* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}


/**
 <#Description#> 保存data
 @param key <#key description#>
 @param value <#value description#>
 */
void saveData(NSString* key,NSData* value)
{
    getUserDefaults();
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}
/**
 <#Description#> 获取String
 @param key <#key description#>
 @returns <#return value description#>
 */
NSData* getData(NSString* key)
{
    getUserDefaults();
    NSData* value=[userDefaults dataForKey:key];
    return value;
}

/**
 <#Description#> 获取String
 @param key <#key description#>
 @returns <#return value description#>
 */
NSString* getString(NSString* key)
{
    getUserDefaults();
    NSString* value=[userDefaults stringForKey:key];
    return value==nil?@"":value;
}

/**
 <#Description#>获取bool
 @param key <#key description#>
 @returns <#return value description#>
 */
bool getBool(NSString* key)
{
    getUserDefaults();
    return [userDefaults boolForKey:key];
}


/**
 <#Description#> 获取Integer
 @param key <#key description#>
 @returns <#return value description#>
 */
int getInteger(NSString* key)
{
    getUserDefaults();
    return (int)[userDefaults integerForKey:key];
}


/**
 <#Description#> 获取Float
 @param key <#key description#>
 @returns <#return value description#>
 */
float getFloat(NSString* key)
{
    getUserDefaults();
    return [userDefaults floatForKey:key];
}


/**
 <#Description#> 获取Double
 @param key <#key description#>
 @returns <#return value description#>
 */
double getDouble(NSString* key)
{
    getUserDefaults();
    return [userDefaults doubleForKey:key];
}

/**
 <#Description#> 获取Array
 @param key <#key description#>
 @returns <#return value description#>
 */
NSArray* getArray(NSString* key)
{
    getUserDefaults();
    return [userDefaults arrayForKey:key];
}

/**
 <#Description#> 获取Dictionary
 @param key <#key description#>
 @returns <#return value description#>
 */
NSDictionary* getDictionary(NSString* key)
{
    getUserDefaults();
    return [userDefaults dictionaryForKey:key];
}


/**
 Description:保存用户版本号
 @param appVersion userName description
 */
void save_AppVersion(NSString* appVersion)
{
    saveString(USER_APP_VERSION,appVersion);
}

/**
 <#Description#> 获取用户版本号
 @returns <#return value description#>
 */
NSString* app_version()
{
    return getString(USER_APP_VERSION);
}



/**
 Description:保存 网络版本号
 @param serverVersion userName description
 */
void save_ServerVersion(NSString* serverVersion)
{
    saveString(APP_SERVER_VERSION,serverVersion);
}

/**
 <#Description#> 获取 网络版本号
 @returns <#return value description#>
 */
NSString* server_version()
{
    return getString(APP_SERVER_VERSION);
}


/**
 Description:保存 审核状态
 @param isReview userName description
 */
void save_isReview(BOOL isReview)
{
    saveBool(APP_IS_REVIEW,isReview);
}

/**
 <#Description#> 获取 审核状态
 @returns <#return value description#>
 */
BOOL app_isreview()
{
    return getBool(APP_IS_REVIEW);
}

/**
 Description:保存 是否强制更新
 @param isForce userName description
 */
void save_isForce(BOOL isForce)
{
    saveBool(APP_ISFORCE,isForce);
}

/**
 <#Description#> 获取 是否强制更新
 @returns <#return value description#>
 */
BOOL app_isfarce()
{
    return getBool(APP_ISFORCE);
}

/**
 Description:保存更新链接
 @param updateLink userName description
 */
void save_UpdateLinke(NSString* updateLink)
{
    saveString(UPDATE_LINK,updateLink);
}

/**
 <#Description#> 获取更新链接
 @returns <#return value description#>
 */
NSString* update_link()
{
    return getString(UPDATE_LINK);
}



/**
 Description:保存用户名
 @param userName userName description
 */
void save_UserName(NSString* userName)
{
    saveString(USER_NAME,userName);
}

/**
 <#Description#> 获取用户名
 @returns <#return value description#>
 */
NSString* user_Name()
{
    return getString(USER_NAME);
}

/**
 Description:保存用户ID
 @param userID userName description
 */
void save_UserID(NSString* userID)
{
    saveString(USER_ID,userID);
}

/**
 <#Description#> 获取用户DI
 @returns <#return value description#>
 */
NSString* user_ID()
{
    return getString(USER_ID);
}

/**
 Description:保存用户头像
 @param userHeadPhoto userName description
 */
void save_UserHeadPhoto(NSString* userHeadPhoto)
{
    saveString(USER_HEAD_PHOTO,userHeadPhoto);
}

/**
 <#Description#> 获取用户头像
 @returns <#return value description#>
 */
NSString* user_headPhoto()
{
    return getString(USER_HEAD_PHOTO);
}


/**
 Description:保存用户昵称
 @param nikeName userName description
 */
void save_NickName(NSString* nikeName)
{
    saveString(NICK_NAME,nikeName);
}

/**
 <#Description#> 获取用户昵称
 @returns <#return value description#>
 */
NSString* nick_Name()
{
    return getString(NICK_NAME);
}

/**
 Description:保存用户邀请码
 @param invitationCode userName description
 */
void save_InvitationCode(NSString* invitationCode)
{
    saveString(MY_INVITATION_CODE,invitationCode);
}

/**
 <#Description#> 获取用户邀请码
 @returns <#return value description#>
 */
NSString* invitation_Code()
{
    return getString(MY_INVITATION_CODE);
}

/**
 Description:保存用户邀请码
 @param invitationCode userName description
 */
void save_NewInvaitationCode(NSString* invitationCode)
{
    saveString(NEW_INVITATION_CODE,invitationCode);
}

/**
 <#Description#> 获取用户邀请码
 @returns <#return value description#>
 */
NSString* newInvitation_Code()
{
    return getString(NEW_INVITATION_CODE);
}


/**
 Description:保存用户上线邀请码
 @param invitationCode userName description
 */
void save_ParentInvitationCode(NSString* invitationCode)
{
    saveString(PARENT_INVITATION_CODE,invitationCode);
}

/**
 <#Description#> 获取用户上线邀请码
 @returns <#return value description#>
 */
NSString* parentInvitation_Code()
{
    return getString(PARENT_INVITATION_CODE);
}


/**
 Description:保存 是否是新手
 @param notFreshMan userName description
 */
void save_NotFreshMan(BOOL notFreshMan)
{
    saveBool(NOT_FRESHMAN,notFreshMan);
}

/**
 <#Description#> 获取 是否是新手
 @returns <#return value description#>
 */
BOOL user_NotFreshMan()
{
    return getBool(NOT_FRESHMAN);
}

/**
 Description:保存 是否填写邀请码
 @param filledCode userName description
 */
void save_FilledInvitationCode(BOOL filledCode)
{
    saveBool(FILLED_INVITATION_CODE,filledCode);
}

/**
 <#Description#> 获取 是否填写邀请码
 @returns <#return value description#>
 */
BOOL filled_invitationCode()
{
    return getBool(FILLED_INVITATION_CODE);
}

/**
 Description:保存accessToken
 @param accessToken userName description
 */
void save_AccessToken(NSString* accessToken)
{
    saveString(ACCESS_TOKEN,accessToken);
}

/**
 <#Description#> 获取用accessToken
 @returns <#return value description#>
 */
NSString* accessToken()
{
    return getString(ACCESS_TOKEN);
}

/**
 Description:保存freshman_city_tag
 @param cityTag userName description
 */
void save_FreshmanCityTag(NSString* cityTag)
{
    saveString(FREAHMAN_CITY_TAG,cityTag);
}

/**
 <#Description#> 获取用freshman_city_tag
 @returns <#return value description#>
 */
NSString* freshmanCityTag()
{
    return getString(FREAHMAN_CITY_TAG);
}

/**
 Description:保存用户设备id
 @param paymentId userName description
 */
void save_DeviceId(NSString* paymentId)
{
    saveString(DEVICE_ID,paymentId);
}

/**
 <#Description#> 获取用用户设备id
 @returns <#return value description#>
 */
NSString* deviceId()
{
    return getString(DEVICE_ID);
}

/**
 Description:保存用户微信id
 @param weixinId userName description
 */
void save_WeixinId(NSString* weixinId)
{
    saveString(WEIXIN_ID,weixinId);
}

/**
 <#Description#> 获取用用户微信id
 @returns <#return value description#>
 */
NSString* weixinId()
{
    return getString(WEIXIN_ID);
}


/**
 Description:保存微信分享的头
 @param shareUrl userName description
 */
void save_WeixinShareUrl(NSString* shareUrl)
{
    saveString(WEIXIN_SHARE_URL,shareUrl);
}

/**
 <#Description#> 获取微信分享的头
 @returns <#return value description#>
 */
NSString* weixinUrl()
{
    return getString(WEIXIN_SHARE_URL);
}

/**
 Description:保存微信分享的头
 @param shareUrl userName description
 */
void save_WeixinAchievementUrl(NSString* shareUrl)
{
    saveString(WEIXIN_ACHIEVEMENT_URL,shareUrl);
}

/**
 <#Description#> 获取微信分享的头
 @returns <#return value description#>
 */
NSString* weixinAchievementUrl()
{
    return getString(WEIXIN_ACHIEVEMENT_URL);
}


/**
 Description:保存用户 QN token
 @param qntoken userName description
 */
void save_qntoken(NSString* qntoken)
{
    saveString(QN_TOKEN,qntoken);
}

/**
 <#Description#> 获取QN token
 @returns <#return value description#>
 */
NSString* qn_token()
{
    return getString(QN_TOKEN);
}
/**
 Description:保存用户 QN voice token
 @param qntoken userName description
 */
void save_qnVoiceToken(NSString* qntoken)
{
    saveString(QN_VOICE_TOKEN,qntoken);
}

/**
 <#Description#> 获取QN voice token
 @returns <#return value description#>
 */
NSString* qn_voice_token()
{
    return getString(QN_VOICE_TOKEN);
}


/**
 Description:保存用户 QN 上传图片
 @param photos userName description
 */
void save_qnphotos(NSArray* photos)
{
    saveArray(QN_PHOTOS,photos);
}

/**
 <#Description#> 获取QN 上传图片
 @returns <#return value description#>
 */
NSArray* qn_photos()
{
    return getArray(QN_PHOTOS);
}

/**
 Description:保存用户 QN 上传声音
 @param voices userName description
 */
void save_qnVoices(NSArray* voices)
{
    saveArray(QN_VOICES,voices);
}

/**
 <#Description#> 获取QN 上传声音
 @returns <#return value description#>
 */
NSArray* qn_voices()
{
    return getArray(QN_VOICES);
}


/**
 Description:保存用户 消息条数
 @param count message_count description
 */
void save_messageCount(int count)
{
    saveInteger(MESSAGE_COUNT, count);
}

/**
 <#Description#> 获取消息条数
 @returns <#return value description#>
 */
int message_count()
{
    return getInteger(MESSAGE_COUNT);
}


/**
 Description:保存用户 搜索历史
 @param seachLoactions userName description
 */
void save_serchLocations(NSArray* seachLoactions)
{
    saveArray(QN_SEARCHLOCATION,seachLoactions);
}

/**
 <#Description#> 获取 搜索历史
 @returns <#return value description#>
 */
NSArray* search_locations()
{
    return getArray(QN_SEARCHLOCATION);
}

/**
 Description:保存 用户年龄
 @param age message_count description
 */
void save_userAge(int age)
{
    saveInteger(USER_AGE, age);
}

/**
 <#Description#> 获取 用户年龄
 @returns <#return value description#>
 */
int user_age()
{
    return getInteger(USER_AGE);
}

/**
 Description:保存用户性别
 @param sex userName description
 */
void save_userSex(NSString* sex)
{
    saveString(USER_SEX,sex);
}

/**
 <#Description#> 获取性别
 @returns <#return value description#>
 */
NSString* user_sex()
{
    return getString(USER_SEX);
}

/**
 Description:保存用户电话
 @param phone userName description
 */
void save_userPhone(NSString* phone)
{
    saveString(USER_PHONE_NUMBER,phone);
}

/**
 <#Description#> 获取电话
 @returns <#return value description#>
 */
NSString* user_phone()
{
    return getString(USER_PHONE_NUMBER);
}

/**
 Description:保存 是否上传位置
 @param isUpload userName description
 */
void save_uploadLocation(BOOL isUpload)
{
    saveBool(USER_UPLOAD_LOCATION,isUpload);
}

/**
 <#Description#> 获取 是否上传位置
 @returns <#return value description#>
 */
BOOL user_uploadLocation()
{
    return getBool(USER_UPLOAD_LOCATION);
}


/**
 Description:保存 原图
 @param isOrange userName description
 */
void save_isOrangePhoto(BOOL isOrange)
{
    saveBool(IS_ORANGE_PHOTO,isOrange);
}

/**
 <#Description#> 获取 原图
 @returns <#return value description#>
 */
BOOL isOrangePhoto()
{
    return getBool(IS_ORANGE_PHOTO);
}

/**
 Description:保存仓库地址
 @param storageAddress userName description
 */
void save_StorageAddress(NSString *storageAddress)
{
    saveString(USER_STORAGE_ADDRESS, storageAddress);
}
/**
 <#Description#> 获取仓库地址
 @returns <#return value description#>
 */
NSString * storageAddress()
{
    return getString(USER_STORAGE_ADDRESS);
}

/**
 Description:保存仓库位置
 @param storageLocation userName description
 */
void save_StorageLocation(NSArray *storageLocation)
{
    saveArray(USER_STORAGE_LOCATION, storageLocation);
}
/**
 <#Description#> 获取仓库位置
 @returns <#return value description#>
 */
NSArray * storageLocation()
{
    return getArray(USER_STORAGE_LOCATION);
}

/**
 Description:保存服务器地址
 @param url userName description
 */
void save_userDiyUrl(NSString* url)
{
    saveString(USER_DIY_URL,url);
}


/**
 <#Description#> 获取服务器地址
 @returns <#return value description#>
 */
NSString* user_diyUrl()
{
    return getString(USER_DIY_URL);
}
