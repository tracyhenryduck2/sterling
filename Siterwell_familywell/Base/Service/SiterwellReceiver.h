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
#import "ItemData.h"
#import <HekrAPI.h>
#import "HekrHttpsApi.h"
#import "TimerModel.h"

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

-(void) onDeviceName:(NSString *)device_name withDevTid:(NSString *)devTid;

-(void) onDeviceStatus:(ItemData *)devicemodel withDevTid:(NSString *)devTid;

-(void) onAnswerOK:(NSString *)devTid;

-(void) onAlert:(NSString *)content withDevTid:(NSString *)devTid;

-(void) onTimerSwitch:(TimerModel *)time withDevTid:(NSString *)devTid;

@end
