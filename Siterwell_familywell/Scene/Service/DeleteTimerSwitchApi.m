//
//  DeleteTimerSwitchApi.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DeleteTimerSwitchApi.h"

@implementation DeleteTimerSwitchApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSNumber *_timerid;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost Content:(NSNumber *)timerid{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _timerid = timerid;
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
                             @"cmdId": @DeleteTimerSwitch,
                             @"device_ID": _timerid
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _connectHost;
}
@end
