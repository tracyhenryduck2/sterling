//
//  DevNetManager.h
//  SiterLink
//
//  Created by CY on 2017/9/4.
//  Copyright © 2017年 CY. All rights reserved.
//

#import "BaseNetManager.h"
#import "ItemData.h"
#import "WarningModel.h"

#define APPID    @"01611410943"

#define randomCode @"97844269618858723534"

#define kDeviceListByFolderPath  @"%@/device/%@?page=%zd&size=20"

#define kDeviceListPath  @"%@/device?page=%zd&size=20"

#define kDevVersionCheckPath  @"/external/device/fw/ota/check"

#define kWarningListPath  @"/api/v1/notification?type=WARNING"

#define kCheckVersionPath  @"http://itunes.apple.com/lookup?id=1249231967"

#define kRegisterByPhone @"/register?type=phone"

#define kResetByPhone @"/resetPassword?type=phone"

#define kChekImg @"/images/checkCaptcha"

#define kGetVerifyCodeResetByPhone @"%@/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=resetPassword&token=%@"

#define kGetVerifyCodeRegisterByPhone @"%@/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=register&token=%@"

#define kRegisterByMail @"%@/register?type=email"

#define kResetByMail @"%@/sendResetPasswordEmail"

#define kGetFolder @"%@/folder"

#define kChangePasswd @"%@/changePassword"

#define kBindPush @"%@/user/pushTagBind"

#define kUnbindPush @"%@/user/unbindPushAlias"

#define kAddFolder @"%@/folder"

#define kRenameFolder @"%@/folder/%@"

#define kDeleteFolder @"%@/folder/%@"

#define kPutIntoFolder @"%@/folder/%@"

#define krenameDevice @"%@/device/%@"

#define kdeleteDevice @"%@/device/%@"

#define kStatusQuery @"%@/deviceStatusQuery"

#define kWarningPath  @"/api/v1/notification?type=WARNING"

#define kClearWarningsPath  @"/api/v1/notification"

@interface DevNetManager : BaseNetManager

+ (id)getDeviceListForFolderId:(NSString *)folderId withPage:(NSInteger)page andBaseUrl:(NSString *)baseurl handler:(void (^)(NSMutableArray <ItemData *>*pArray, NSError *error))handler;

+ (id)getDeviceList:(NSInteger)page andBaseUrl:(NSString *)baseurl handler:(void (^)(id, NSError *))handler;

+(id)checkImg:(NSString *)code andBaseUrl:(NSString *)baseurl handler:(void(^)(NSString *,NSError *)) handler;

+(id)getVerifyCodeRegisterByPhone:(NSString *)phoneNumber withToken:(NSString *)token andBaseUrl:(NSString *)baseurl handler:(void (^)(id,NSError *))handler;

+(id)getVerifyCodeResetByPhone:(NSString *)phoneNumber withToken:(NSString *)token andBaseUrl:(NSString *)baseurl handler:(void (^)(id,NSError *))handler;

+(id)registerByPhone:(NSString *)phoneNumber withPasswd:(NSString *)pwd withcode:(NSString *)code andBaseUrl:(NSString *)baseurl handler:(void (^)(NSError *)) handler;

+(id)resetByPhone:(NSString *)phoneNumber withPasswd:(NSString *)pwd withcode:(NSString *)code andBaseUrl:(NSString *)baseurl handler:(void(^)(NSError *)) handler;

+(id)registerByMail:(NSString *)email withPasswd:(NSString *)pwd andBaseUrl:(NSString *)baseurl handler:(void (^)(NSError *)) handler;

+(id)resetByMail:(NSString *)email andBaseUrl:(NSString *)baseurl handler:(void(^)(NSError *)) handler;

+(id)changePasswd:(NSString *)oldpwd andNewPasswd:(NSString *)newpasswd andBaseUrl:(NSString *)baseurl handler:(void(^)(NSError *)) handler;

+(id)getFolders:(NSString *)baseurl handler:(void(^)(id,NSError *)) handler;

+(id)bindPush:(NSString *)clientid withLan:(NSString *)lan andBaseUrl:(NSString *)baseurl hander:(void(^)(NSError *)) handler;

+(id)unBindPush:(NSString *)clientid andBaseUrl:(NSString *)baseurl hander:(void(^)(NSError *)) handler;

+(id)addFolder:(NSString *) folderName andBaseUrl:(NSString *)baseurl hanlder :(void(^)(NSError *)) handler;

+(id)reNameFolder:(NSString *)newName withFolderId:(NSString *)folderId andBaseUrl:(NSString *)baseurl hander:(void(^)(NSError *)) handler;

+(id)deleteFolder:(NSString *)folderId andBaseUrl:(NSString *)baseurl hander:(void(^)(NSError *)) handler;

+(id)reNameDevice:(NSString *)newName withdevTid:(NSString *)devTid withctrlKey:(NSString *)ctrlKey withConnectHost:(NSString *)connectHost andBaseUrl:(NSString *)baseurl hanlder :(void(^)(NSError *)) handler;

+(id)deleteDevice:(NSString *)devTid withbinKey:(NSString *)bindkey andBaseUrl:(NSString *)baseurl hanlder :(void(^)(NSError *)) handler;

+(id)putDeviceIntoFolder:(NSString *)folderId withDevTid:(NSString *)devTid withCtrlKey:(NSString *)ctrlkey andBaseUrl:(NSString *)baseurl hanlder :(void(^)(NSError *)) handler;

+(id)queryStatus:(NSArray *) array andBaseUrl:(NSString *)baseurl hanlder :(void(^)(id,NSError *)) handler;

+ (id)clearAllWarningsWithDevTid:(NSString *)devTid ctrlKey:(NSString *)ctrlKey handler:(void (^)(NSError *))handler;

+ (id)getWarningsWithDevTid:(NSString *)devTid andPage:(NSInteger)page handler:(void (^)(NSArray<WarningModel *> *, BOOL, NSError *))handler;
@end
