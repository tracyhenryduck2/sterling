//
//  RenameDeviceApi.m
//  sHome
//
//  Created by shap on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "RenameDeviceApi.h"

@implementation RenameDeviceApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    int _deviceId;
    NSString *_deviceName;
    NSString *_connecthost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey DeviceId:(int)deviceId DeviceName:(NSString *)deviceName ConnectHost:(NSString *)connecthost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _deviceId = deviceId;
        _deviceName = [NameHelper getASCIIFromName:deviceName];
        _connecthost = connecthost;
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
                             @"cmdId": @EditDeviceName,
                             @"device_ID": @(_deviceId),
                             @"device_name": _deviceName
                             }
                     }
             };
}

- (id)requestArgumentConnectHost {
    return _connecthost;
}


@end
