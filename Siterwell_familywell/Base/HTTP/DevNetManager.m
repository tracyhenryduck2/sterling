//
//  DevNetManager.m
//  SiterLink
//
//  Created by CY on 2017/9/4.
//  Copyright © 2017年 CY. All rights reserved.
//

#import "DevNetManager.h"


@implementation DevNetManager


+ (id)getDeviceList:(NSInteger)page andBaseUrl:(NSString *)baseurl handler:(void (^)(id, NSError *))handler {
    NSString *path = [NSString stringWithFormat:kDeviceListPath,baseurl, page];
    return [self GET:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        !handler ?: handler(responseObj, error);
    }];
}




+(id)checkImg:(NSString *)code andBaseUrl:(NSString *)baseurl handler:(void(^)(NSString *,NSError *)) handler{
    
    NSDictionary *param = @{@"rid": randomCode,
                            @"code": code};
    
    return [self POST:[NSString stringWithFormat:@"%@%@",baseurl,kChekImg] parameters:param completionHandler:^(id responseObj, NSError *error) {
        !handler ?: handler(responseObj[@"captchaToken"], error);
    }];
}

+(id)getVerifyCodeRegisterByPhone:(NSString *)phoneNumber withToken:(NSString *)token andBaseUrl:(NSString *)baseurl handler:(void (^)(id,NSError *))handler{
    return [self GET:[NSString stringWithFormat:kGetVerifyCodeRegisterByPhone,baseurl,phoneNumber,APPID,token ] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        !handler ?: handler(responseObj, error);
    }];
}

+(id)getVerifyCodeResetByPhone:(NSString *)phoneNumber withToken:(NSString *)token andBaseUrl:(NSString *)baseurl handler:(void (^)(id,NSError *))handler{
    
    
    return [self GET:[NSString stringWithFormat:kGetVerifyCodeResetByPhone,baseurl,phoneNumber,APPID,token ] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        !handler ?: handler(responseObj, error);
    }];
}

+(id)registerByPhone:(NSString *)phoneNumber withPasswd:(NSString *)pwd withcode:(NSString *)code andBaseUrl:(NSString *)baseurl handler:(void (^)(NSError *)) handler{
    
    NSDictionary * param = @{@"pid": APPID, @"phoneNumber": phoneNumber, @"password": pwd,@"code":code};
    
    return [self POST:[NSString stringWithFormat:@"%@%@",baseurl,kRegisterByPhone] parameters:param completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
}

+(id)resetByPhone:(NSString *)phoneNumber withPasswd:(NSString *)pwd withcode:(NSString *)code andBaseUrl:(NSString *)baseurl handler:(void(^)(NSError *)) handler{
     NSDictionary * param = @{@"pid": APPID, @"phoneNumber": phoneNumber, @"password": pwd,@"verifyCode":code};
    return [self POST:[NSString stringWithFormat:@"%@%@",baseurl,kResetByPhone] parameters:param completionHandler:^(id responseObj, NSError *error) {
         !handler?:handler(error);
    }];
}

+(id)registerByMail:(NSString *)email withPasswd:(NSString *)pwd andBaseUrl:(NSString *)baseurl handler:(void (^)(NSError *)) handler{
        NSDictionary *param = @{@"pid": APPID, @"email": email, @"password": pwd};
    
    return [self POST:[NSString stringWithFormat:kRegisterByMail,baseurl] parameters:param completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
    
}

+(id)resetByMail:(NSString *)email andBaseUrl:(NSString *)baseurl handler:(void(^)(NSError *)) handler{
    NSDictionary *param = @{@"email": email, @"pid": APPID};
    
    return [self GET:[NSString stringWithFormat:kResetByMail,baseurl] parameters:param completionHandler:^(id responseObj, NSError *error) {
         !handler?:handler(error);
    }];
}

+(id)changePasswd:(NSString *)oldpwd andNewPasswd:(NSString *)newpasswd andBaseUrl:(NSString *)baseurl handler:(void(^)(NSError *)) handler{
        NSDictionary *param = @{@"pid": APPID, @"oldPassword": oldpwd, @"newPassword": newpasswd};
    
    return [self POST:[NSString stringWithFormat:kChangePasswd,baseurl] parameters:param completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
}

+(id)getFolders:(NSString *)baseurl handler:(void(^)(id,NSError *)) handler{
    return [self GET:[NSString stringWithFormat:kGetFolder,baseurl] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(responseObj,error);
    }];
}

+(id)bindPush:(NSString *)clientid withLan:(NSString *)lan andBaseUrl:(NSString *)baseurl hander:(void(^)(NSError *)) handler{
    NSDictionary *dic = @{
                          @"clientId" : clientid,
                          @"pushPlatform" : @"GETUI",
                          @"locale" : lan
                          };
    
    return [self POST:[NSString stringWithFormat:kBindPush,baseurl] parameters:dic completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
    
}

+(id)unBindPush:(NSString *)clientid andBaseUrl:(NSString *)baseurl hander:(void(^)(NSError *)) handler{
    NSDictionary *params = @{@"clientId": clientid,
                             @"pushPlatform": @"GETUI"
                             };
    
    return [self POST:[NSString stringWithFormat:kUnbindPush,baseurl] parameters:params completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
    
}

+(id)reNameFolder:(NSString *)newName withFolderId:(NSString *)folderId andBaseUrl:(NSString *)baseurl hander:(void(^)(NSError *)) handler{
    return [self PUT:[NSString stringWithFormat:kRenameFolder,baseurl,folderId] parameters:@{@"newFolderName": newName} completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
}

+(id)deleteFolder:(NSString *)folderId andBaseUrl:(NSString *)baseurl hander:(void(^)(NSError *)) handler{
    return [self DELETE:[NSString stringWithFormat:kDeleteFolder,baseurl,folderId] parameters:nil completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
}

+(id)reNameDevice:(NSString *)newName withdevTid:(NSString *)devTid withctrlKey:(NSString *)ctrlKey withConnectHost:(NSString *)connectHost andBaseUrl:(NSString *)baseurl hanlder :(void(^)(NSError *)) handler {
    
   NSDictionary *param = @{@"deviceName": newName, @"ctrlKey": ctrlKey};
    return [self PATCH:[NSString stringWithFormat:krenameDevice,baseurl,devTid] parameters:param completionHandler:^(id responseObj, NSError *error) {
         !handler?:handler(error);
    }];
}

+(id)deleteDevice:(NSString *)devTid withbinKey:(NSString *)bindkey andBaseUrl:(NSString *)baseurl hanlder :(void(^)(NSError *)) handler{
    NSDictionary *params = @{@"bindKey": bindkey};
    return [self DELETE:[NSString stringWithFormat:kdeleteDevice,baseurl,devTid] parameters:params completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
}

+(id)putDeviceIntoFolder:(NSString *)folderId withDevTid:(NSString *)devTid withCtrlKey:(NSString *)ctrlkey andBaseUrl:(NSString *)baseurl hanlder :(void(^)(NSError *)) handler{
    NSDictionary *param = @{@"devTid": devTid, @"ctrlKey": ctrlkey };
    return [self POST:[NSString stringWithFormat:kPutIntoFolder,baseurl,folderId] parameters:param completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
}

+(id)addFolder:(NSString *) folderName andBaseUrl:(NSString *)baseurl hanlder :(void(^)(NSError *)) handler{
      NSDictionary *param = @{@"folderName": folderName };
    return [self POST:[NSString stringWithFormat:kAddFolder,baseurl] parameters:param completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(error);
    }];
}

+(id)queryStatus:(NSArray *) array andBaseUrl:(NSString *)baseurl hanlder :(void(^)(id,NSError *)) handler{
    return [self POSTArray:[NSString stringWithFormat:kStatusQuery,baseurl] parameters:array completionHandler:^(id responseObj, NSError *error) {
        !handler?:handler(responseObj,error);
    }];
}
@end
