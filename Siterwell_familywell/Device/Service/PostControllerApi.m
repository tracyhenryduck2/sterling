//
//  PostControllerApi.m
//  sHome
//
//  Created by shaop on 2017/1/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "PostControllerApi.h"

@implementation PostControllerApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSNumber * _deviceId;
    NSString *_deviceStatus;
    NSString *_connectHost;
}

-(id)initWithDrivce:(NSString *)devTid andCtrlKey:(NSString *)ctrlkey DeviceID:(NSNumber *)dev_ID DeviceStatus:(NSString *)device_status ConnectHost:(NSString *)connecthost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlkey;
        _deviceId = dev_ID;
        _deviceStatus = device_status;
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
                             @"cmdId": @ControllDevice,
                             @"device_ID": _deviceId,
                             @"device_status": _deviceStatus
                             }
                     }
             };
}

- (id)requestArgumentConnectHost{
    return _connectHost;
}


@end
