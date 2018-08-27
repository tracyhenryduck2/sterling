//
//  AddSystemSceneApi.m
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AddSystemSceneApi.h"

@implementation AddSystemSceneApi
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
                             @"cmdId": @AddSystemScene,
                             @"scene_content": _content
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _connectHost;
}
@end
