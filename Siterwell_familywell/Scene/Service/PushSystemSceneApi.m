//
//  PushSystemSceneApi.m
//  sHome
//
//  Created by shap on 2017/4/2.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "PushSystemSceneApi.h"

@implementation PushSystemSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_scene_content;
    NSString *_connectHost;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost SceneContent:(NSString *)scene_content{
    if (self = [super init]) {
        _devTid = devTid;
        _scene_content = scene_content;
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
                             @"cmdId":@EditSystemScene,
                             @"scene_content":_scene_content
                             }
                     }
             };
}


- (id)requestArgumentConnectHost{
    return _connectHost;
}

@end
