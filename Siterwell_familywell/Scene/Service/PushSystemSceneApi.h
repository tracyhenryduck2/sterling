//
//  PushSystemSceneApi.h
//  sHome
//
//  Created by shap on 2017/4/2.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface PushSystemSceneApi : BaseDriveApi

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost SceneContent:(NSString *)scene_content;

@end
