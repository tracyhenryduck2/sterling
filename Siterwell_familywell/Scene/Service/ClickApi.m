//
//  ClickApi.m
//  Siterwell_familywell
//
//  Created by Henry on 2019/1/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "ClickApi.h"

@implementation ClickApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSNumber *_scene_id;
    NSString *_conncetHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost Scene:(NSNumber *)scene_id{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _conncetHost = conncetHost;
        _scene_id = scene_id;
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
                             @"cmdId": @ClickToAction,
                             @"indexed": _scene_id
                             }
                     }
             };
}

- (id)requestArgumentConnectHost{
    return _conncetHost;
}

@end
