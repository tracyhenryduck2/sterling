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
#import "DeviceModel.h"
#import "SystemSceneModel.h"
#import "SceneModel.h"
#import "BatterHelp.h"
#import "NameHelper.h"
@interface CRCqueueHelp : NSObject

+(NSString *)getDeviceCRCContent:(NSMutableArray *)deviceArray;
+(NSString *)getSystemSceneCRCContent:(NSMutableArray *)SystemSceneArray withDevTid:(NSString *)devTid;
+(NSString *)getSceneCRCContent:(NSMutableArray *)SceneArray;
@end

#endif /* DeviceCRCqueueHelp_h */
