//
//  ChooseSystemSceneApi.m
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ChooseSystemSceneApi.h"

@implementation ChooseSystemSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSNumber *_scene_group;
    NSString *_conncetHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost SceneGroup:(NSNumber *)scene_group{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _conncetHost = conncetHost;
        _scene_group = scene_group;
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
                             @"cmdId": @ChooseSystemScene,
                             @"scene_type": _scene_group
                             }
                     }
             };
}

- (id)requestArgumentConnectHost{
    return _conncetHost;
}

@end
