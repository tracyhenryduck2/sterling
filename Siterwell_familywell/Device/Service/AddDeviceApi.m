//
//  AddDeviceApi.m
//  sHome
//
//  Created by shaop on 2017/1/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AddDeviceApi.h"

@implementation AddDeviceApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_conntectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey ConnectHost:(NSString *)connecthost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _conntectHost = connecthost;
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
                             @"cmdId": @2
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _conntectHost;
}

@end
