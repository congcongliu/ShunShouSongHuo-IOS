//
//  CCUserData.h
//  shunshouzhuanqian
//
//  Created by CongCong on 16/4/5.
//  Copyright © 2016年 CongCong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USER_APP_VERSION       @"user_app_version"
#define APP_SERVER_VERSION     @"app_server_version"
#define APP_IS_REVIEW          @"app_is_review"
#define APP_ISFORCE            @"is_force"
#define USER_NAME              @"user_name"
#define UPDATE_LINK            @"update_link"
#define USER_ID                @"user_id"
#define USER_HEAD_PHOTO        @"head_photo"
#define WEIXIN_ID              @"third_party_account_id"
#define WEIXIN_SHARE_URL       @"weixin_share_url"
#define WEIXIN_ACHIEVEMENT_URL @"task_achievement_page_url"
#define QN_TOKEN               @"qn_token"
#define QN_VOICE_TOKEN         @"qn_voice_token"
#define QN_PHOTOS              @"qn_photos"
#define QN_VOICES              @"qn_voices"
#define QN_SEARCHLOCATION      @"search_location"
#define NICK_NAME              @"nickname"
#define MY_INVITATION_CODE     @"my_invitation_code"
#define NEW_INVITATION_CODE    @"new_invitation_code"
#define PARENT_INVITATION_CODE @"parent_invitation_code"
#define NOT_FRESHMAN           @"not_freshman"
#define FILLED_INVITATION_CODE @"filled_invitation_code"
#define ACCESS_TOKEN           @"access_token"
#define FREAHMAN_CITY_TAG      @"freshman_city_tag"
#define ACTIVIT_ID             @"activity_id"
#define MESSAGE_COUNT          @"message_count"
#define DEVICE_ID              @"device_registration_id"
#define USER_AGE               @"age"
#define USER_SEX               @"sex"
#define USER_PHONE_NUMBER      @"mobile_phone"
#define USER_UPLOAD_LOCATION   @"user_upload_loaction"
#define IS_ORANGE_PHOTO        @"is_orange_photo"
#define USER_STORAGE_ADDRESS   @"user_storage_address"
#define USER_STORAGE_LOCATION  @"user_storage_location"
#define USER_DIY_URL           @"user_diy_url"


void save_AppVersion(NSString* appVersion);
NSString* app_version();
void save_ServerVersion(NSString* serverVersion);
NSString* server_version();
void save_isReview(BOOL isReview);
BOOL app_isreview();
void save_UserName(NSString* userName);
NSString* user_Name();
void save_NickName(NSString* nikeName);
NSString* nick_Name();
void save_AccessToken(NSString* accessToken);
NSString* accessToken();
void save_DeviceId(NSString* paymentId);
NSString* deviceId();
void save_WeixinId(NSString* weixinId);
NSString* weixinId();
void save_UserID(NSString* userID);
NSString* user_ID();
void save_UserHeadPhoto(NSString* userHeadPhoto);
NSString* user_headPhoto();
void save_qntoken(NSString* qntoken);
NSString* qn_token();
void save_qnphotos(NSArray* photos);
NSArray* qn_photos();
void save_messageCount(int count);
int message_count();
void save_serchLocations(NSArray* seachLoactions);
NSArray* search_locations();
void save_isForce(BOOL isForce);
BOOL app_isfarce();
void save_UpdateLinke(NSString* updateLink);
NSString* update_link();
void save_qnVoiceToken(NSString* qntoken);
NSString* qn_voice_token();
void save_qnVoices(NSArray* voices);
NSArray* qn_voices();
void save_WeixinShareUrl(NSString* shareUrl);
NSString* weixinUrl();
void save_InvitationCode(NSString* invitationCode);
NSString* invitation_Code();
void save_NotFreshMan(BOOL notFreshMan);
BOOL user_NotFreshMan();
void save_FilledInvitationCode(BOOL filledCode);
BOOL filled_invitationCode();
void save_ParentInvitationCode(NSString* invitationCode);
NSString* parentInvitation_Code();
void save_WeixinAchievementUrl(NSString* shareUrl);
NSString* weixinAchievementUrl();
void save_FreshmanCityTag(NSString* cityTag);
NSString* freshmanCityTag();
void save_userAge(int age);
int user_age();
void save_userSex(NSString* sex);
NSString* user_sex();
void save_userPhone(NSString* phone);
NSString* user_phone();
void save_uploadLocation(BOOL isUpload);
BOOL user_uploadLocation();
void save_isOrangePhoto(BOOL isOrange);
BOOL isOrangePhoto();
void save_NewInvaitationCode(NSString* invitationCode);
NSString* newInvitation_Code();
void save_StorageAddress(NSString *storageAddress);
NSString * storageAddress();
void save_StorageLocation(NSArray *storageLocation);
NSArray * storageLocation();
void save_userDiyUrl(NSString* url);
NSString* user_diyUrl();


