//
//  ScynDeviceApi.m
//  sHome
//
//  Created by shaop on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ScynDeviceApi.h"
#import "DeviceModel.h"
#import "BatterHelp.h"

@implementation ScynDeviceApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_deviceCRCqueue;
    NSString *_connectHost;
}

-(id)initWithDrivce:(NSString *)devTid andCtrlKey:(NSString *)ctrlkey DeviceStatus:(NSString *)device_status ConnectHost:(NSString *)connecthost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlkey;
        _deviceCRCqueue = device_status;
        _connectHost = connecthost;
    }
    return self;
}



-(id)requestArgumentConnectHost{
    return _connectHost;
}


-(id)requestArgumentCommand{
    return @{
             @"action":@"appSend",
             @"params": @{
                     @"devTid":_devTid,
                     @"ctrlKey":_ctrlKey,
                     @"data":@{
                             @"cmdId":@SyncDevice,
                             @"device_status":_deviceCRCqueue
                             }
                     }
             };
}


@end
