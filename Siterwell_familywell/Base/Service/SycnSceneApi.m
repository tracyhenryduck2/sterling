//
//  SycnSceneApi.m
//  sHome
//
//  Created by shaop on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SycnSceneApi.h"

@implementation SycnSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_connectHost;
    NSString *_scene_group;
    NSString *_scene_content;
    NSString *_answer_content;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)connectHost SceneGroup:(NSString *)scene_group answerContent:(NSString *)answer_content SceneContent:(NSString *)scene_content{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _connectHost = connectHost;
        _scene_group = scene_group;
        _scene_content = scene_content;
        _answer_content = answer_content;
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
                             @"cmdId":@31,
                             @"sence_group":@([_scene_group intValue]),
                             @"answer_content":_answer_content,
                             @"scene_content":_scene_content
                             }
                     }
             };
}



- (id)requestArgumentConnectHost{
    return _connectHost;
}
@end
