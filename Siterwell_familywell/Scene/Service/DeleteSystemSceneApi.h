//
//  DeleteSystemSceneApi.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/10/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DeleteSystemSceneApi_h
#define DeleteSystemSceneApi_h
#import "BaseDriveApi.h"

@interface DeleteSystemSceneApi : BaseDriveApi

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost Content:(NSNumber *)sid;

@end

#endif /* DeleteSystemSceneApi_h */
