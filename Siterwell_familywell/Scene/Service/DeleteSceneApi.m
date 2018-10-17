//
//  DeleteSceneApi.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/16.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DeleteSceneApi.h"

@implementation DeleteSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSNumber *_scene_id;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost SceneContent:(NSNumber *)scene_id{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _scene_id = scene_id;
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
                             @"cmdId": @DelteScene,
                             @"scene_type":@0,
                             @"scene_ID": _scene_id
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _connectHost;
}
@end
