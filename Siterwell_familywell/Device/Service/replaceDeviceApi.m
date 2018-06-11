//
//  replaceDeviceApi.m
//  sHome
//
//  Created by shaop on 2016/12/29.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "replaceDeviceApi.h"

@implementation replaceDeviceApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_mDeviceId;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey mDeviceID:(NSString *)mDeviceId ConnectHost:(NSString *)connecthost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _mDeviceId = mDeviceId;
        _connectHost = connecthost;
    }
    return self;
}

- (id)requestArgumentCommand {
    NSDictionary *dic = @{
                          @"action": @"appSend",
                          @"params": @{
                                  @"devTid": _devTid,
                                  @"ctrlKey": _ctrlKey,
                                  @"data": @{
                                          @"device_ID": _mDeviceId,
                                          @"cmdId": @3
                                          }
                                  }
                          };
    return dic;
}


- (NSString *)requestArgumentHost{
    return _connectHost;
}
@end
