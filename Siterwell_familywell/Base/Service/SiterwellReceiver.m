//
//  siterwellsdk.m
//  siterwellsdk
//
//  Created by TracyHenry on 2018/6/19.
//  Copyright © 2018年 ST. All rights reserved.
//

#import "SiterwellReceiver.h"
#import "HekrAPI.h"


@implementation SiterwellReceiver


#pragma mark -sharesInstance

-(void) recv:(id) obj callback:(void(^)(id obj,id data,NSError*)) block{
    
    //无法放在一起些...读取cmd = 26（系统情景）的数据
    NSDictionary *dic = @{
                          @"action" : @"devSend",
                          };
    
    [[Hekr sharedInstance] recv:dic obj:obj callback:^(id obj,id data,NSError* error){
        
        if(!error){
            NSNumber *cmd = data[@"params"][@"data"][@"cmdId"];
            
            if([cmd intValue] == SCENE_MODE_UPLOAD){
                SystemSceneModel *model = [[SystemSceneModel alloc] initWithHekrDictionary:data error:nil];
                [self.siterwelldelegate onUpdateOnSystemScene:model];
            }else if([cmd intValue] == SCENE_UPLOAD){
                SceneModel *scenemodel = [[SceneModel alloc] initWithHekrDictionary:data error:nil];
                [self.siterwelldelegate onUpdateOnScene:scenemodel];
            }else if([cmd intValue] == CURRENT_SCENE_UPLOAD){
                
            }
            block(obj,data,error);
        }
        
    }];
    
};

@end
