//
//  siterwellsdk.m
//  siterwellsdk
//
//  Created by TracyHenry on 2018/6/19.
//  Copyright © 2018年 ST. All rights reserved.
//

#import "SiterwellReceiver.h"
#import "HekrAPI.h"
#import "Encryptools.h"

@implementation SiterwellReceiver


#pragma mark -sharesInstance

-(void) recv:(id) obj callback:(void(^)(id obj,id data,NSError*)) block{
    
    //无法放在一起些...读取cmd = 26（系统情景）的数据
    NSDictionary *dic = @{
                          @"action" : @"devSend",
                          };
    
    [[Hekr sharedInstance] recv:dic obj:obj callback:^(id obj,id data,NSError* error){
        
        if(!error){
            NSNumber *msgId = data[@"msgId"];
            NSNumber *cmd = data[@"params"][@"data"][@"cmdId"];
            NSString *devTid = data[@"params"][@"devTid"];
            if([cmd intValue] == SCENE_MODE_UPLOAD){
                SystemSceneModel *model = [[SystemSceneModel alloc] initWithHekrDictionary:data error:nil];
                NSNumber *sence_group = data[@"params"][@"data"][@"sence_group"];
                [model create:sence_group];
                [self.siterwelldelegate onUpdateOnSystemScene:model withDevTid:devTid];
            }else if([cmd intValue] == (SCENE_MODE_UPLOAD+100)){
                SystemSceneModel *model = [[SystemSceneModel alloc] initWithHekrDictionary:data error:nil];
                NSNumber *sence_group = data[@"params"][@"data"][@"sence_group"];
                int newa = [Encryptools getDescryption:[sence_group intValue] withMsgId:[msgId intValue]];
                [model create:[NSNumber numberWithInt:newa]];
                [self.siterwelldelegate onUpdateOnSystemScene:model withDevTid:devTid];
            }else if([cmd intValue] == SCENE_UPLOAD){
                SceneModel *scenemodel = [[SceneModel alloc] initWithHekrDictionary:data error:nil];
                NSNumber *scene_type = data[@"params"][@"data"][@"scene_type"];
                [scenemodel create:scene_type];
                [self.siterwelldelegate onUpdateOnScene:scenemodel withDevTid:devTid];
            }else if([cmd intValue] == (SCENE_UPLOAD+100)){
                SceneModel *scenemodel = [[SceneModel alloc] initWithHekrDictionary:data error:nil];
                NSNumber *scene_type = data[@"params"][@"data"][@"scene_type"];
                int newa = [Encryptools getDescryption:[scene_type intValue] withMsgId:[msgId intValue]];
                [scenemodel create:[NSNumber numberWithInt:newa]];
                [self.siterwelldelegate onUpdateOnScene:scenemodel withDevTid:devTid];
            }else if([cmd intValue] == CURRENT_SCENE_UPLOAD){
                NSNumber *current_scenemode = data[@"params"][@"data"][@"sence_group"];
                [self.siterwelldelegate onUpdateOnCurrentSystemScene:current_scenemode withDevTid:devTid];
            }else if([cmd intValue] == (CURRENT_SCENE_UPLOAD+100)){
                NSNumber *current_scenemode = data[@"params"][@"data"][@"sence_group"];
                int newa = [Encryptools getDescryption:[current_scenemode intValue] withMsgId:[msgId intValue]];
                [self.siterwelldelegate onUpdateOnCurrentSystemScene:[NSNumber numberWithInt:newa] withDevTid:devTid];
            }else if([cmd intValue] == DEVICE_STATUS_UPLOAD){
                ItemData *devmodel = [[ItemData alloc] initWithHekrDictionary:data error:nil];
                [self.siterwelldelegate onDeviceStatus:devmodel withDevTid:devTid];
            }else if([cmd intValue] == (DEVICE_STATUS_UPLOAD+100)){
                ItemData *devmodel = [[ItemData alloc] initWithHekrDictionary:data error:nil];
                int newa = [Encryptools getDescryption:[devmodel.device_ID intValue] withMsgId:[msgId intValue]];
                [devmodel setDevice_ID:[NSNumber numberWithInt:newa]];
                [self.siterwelldelegate onDeviceStatus:devmodel withDevTid:devTid];
            }else if([cmd intValue] == ANWSER_OK){
                [self.siterwelldelegate onAnswerOK:devTid];
            }else if([cmd intValue] == GATEWAY_ALERT_INFO){
                NSString *answer_content = data[@"params"][@"data"][@"answer_content"];
                [self.siterwelldelegate onAlert:answer_content withDevTid:devTid];
            }
            block(obj,data,error);
        }
        
    }];
    
};

@end
