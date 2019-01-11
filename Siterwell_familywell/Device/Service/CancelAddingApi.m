//
//  CancelAddingApi.m
//  sHome
//
//  Created by shaop on 2017/4/20.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "CancelAddingApi.h"

@implementation CancelAddingApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey ConnectHost:(NSString *)connecthost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _connectHost = connecthost;
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
                             @"cmdId": @CancelAddDevice
                             }
                     }
             };
}



- (id)requestArgumentConnectHost{
    return _connectHost;
}

@end
