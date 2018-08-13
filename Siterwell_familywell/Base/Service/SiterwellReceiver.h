//
//  siterwellsdk.h
//  siterwellsdk
//
//  Created by TracyHenry on 2018/6/19.
//  Copyright © 2018年 ST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BatterHelp.h"
#import "SystemSceneModel.h"
#import "SceneModel.h"
#import "DeviceModel.h"
#import <HekrAPI.h>

#define ANWSER_OK  11
#define DEVICE_NAME_UPLOAD 17
#define DEVICE_STATUS_UPLOAD 19
#define GATEWAY_NEED_TIME 22
#define GATEWAY_ALERT_INFO 25
#define SCENE_MODE_UPLOAD 26
#define SCENE_UPLOAD 27
#define CURRENT_SCENE_UPLOAD 28
#define TIMER_UPLOAD 36

@protocol SiterwellDelegate;

@interface SiterwellReceiver : NSObject

@property (nonatomic,strong) id<SiterwellDelegate> siterwelldelegate;

-(void) recv:(id) obj callback:(void(^)(id obj,id data,NSError*)) block;
@end


@protocol SiterwellDelegate

-(void) onlinestatus:(NSString *)devTid;

-(void) onUpdateOnSystemScene:(SystemSceneModel *) systemscenemodel withDevTid:(NSString *)devTid;

-(void) onUpdateOnScene:(SceneModel *)scenemodel withDevTid:(NSString *)devTid;

-(void) onUpdateOnCurrentSystemScene:(NSNumber *)currentmodel withDevTid:(NSString *)devTid;

-(void) onDeviceStatus:(DeviceModel *)devicemodel withDevTid:(NSString *)devTid;

-(void) onAnswerOK;
@end
