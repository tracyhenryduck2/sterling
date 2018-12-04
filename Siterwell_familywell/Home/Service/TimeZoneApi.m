//
//  AddSystemSceneApi.m
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "TimeZoneApi.h"

@implementation TimeZoneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSInteger _zoneOffset;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone] ;///获取当前时区信息
        NSInteger sourceGMTOffset = [destinationTimeZone secondsFromGMTForDate:[NSDate date]];///获取偏移秒数
        _zoneOffset = sourceGMTOffset/3600;
        _zoneOffset = _zoneOffset > 0 ? _zoneOffset : 256 + _zoneOffset;
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
                             @"cmdId": @GATEWAYTIMEZONE_UPLOAD,
                             @"TimeZone": @(_zoneOffset)
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _connectHost;
}
@end
