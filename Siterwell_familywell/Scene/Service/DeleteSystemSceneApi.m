//
//  DeleteSystemSceneApi.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DeleteSystemSceneApi.h"
@implementation DeleteSystemSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSNumber *_sid;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost Content:(NSNumber *)sid{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _sid = sid;
        _connectHost = conncetHost;
    }
    return self;
}

- (id)requestArgumentCommand {
    return @{
             @"action": @"appSend",
             @"params": @{
                     @"devTid": _devTid,
                     @"ctrlKey": _ctrlKey,
                     @"data": @{
                             @"cmdId": @DeleteSystemScene,
                             @"sence_group": _sid
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _connectHost;
}

@end
