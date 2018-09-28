//
//  AddSceneApi.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef AddSceneApi_h
#define AddSceneApi_h
#import "BaseDriveApi.h"

@interface AddSceneApi : BaseDriveApi

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost SceneContent:(NSString *)content;

@end

#endif /* AddSceneApi_h */
