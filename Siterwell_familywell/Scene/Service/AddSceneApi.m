//
//  AddSceneApi.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "AddSceneApi.h"

@implementation AddSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_content;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost SceneContent:(NSString *)content{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _content = content;
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
                             @"cmdId": @AddScene,
                             @"scene_type": @"0",
                             @"scene_content": _content
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _connectHost;
}
@end
