//
//  AddSystemSceneApi.m
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "UploadTimeApi.h"
#import "TimeHelper.h"
@implementation UploadTimeApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
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
                             @"cmdId": @GATEWAYTIME_UPLOAD,
                             @"time": [TimeHelper getSTHTime]
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _connectHost;
}
@end
