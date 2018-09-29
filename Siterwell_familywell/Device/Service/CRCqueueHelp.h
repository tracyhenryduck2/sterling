//
//  CRCqueueHelp.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/30.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef CRCqueueHelp_h
#define CRCqueueHelp_h
#import "DBDeviceManager.h"
#import "DBSceneReManager.h"
#import "DBGS584RelationShipManager.h"
#import "ItemData.h"
#import "SystemSceneModel.h"
#import "SceneModel.h"
#import "BatterHelp.h"
#import "NameHelper.h"
#import "TimerModel.h"
#import "DBTimerManager.h"
#import "ContentHepler.h"
@interface CRCqueueHelp : NSObject

//获取设备队列crc
+(NSString *)getDeviceCRCContent:(NSMutableArray *)deviceArray;
//获取情景模式队列crc
+(NSString *)getSystemSceneCRCContent:(NSMutableArray *)SystemSceneArray withDevTid:(NSString *)devTid;
//获取自定义情景队列crc
+(NSString *)getSceneCRCContent:(NSMutableArray *)SceneArray;
//获取定时任务队列crc
+(NSString *)getTimerCRCS:(NSMutableArray <TimerModel *>*)slist withDevTid:(NSString *)devTid;
@end

#endif /* DeviceCRCqueueHelp_h */
