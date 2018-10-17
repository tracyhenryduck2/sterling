//
//  DeleteSceneApi.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/16.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DeleteSceneApi_h
#define DeleteSceneApi_h
#import "BaseDriveApi.h"

@interface DeleteSceneApi : BaseDriveApi

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost SceneContent:(NSNumber *)scene_id;

@end

#endif /* DeleteSceneApi_h */
