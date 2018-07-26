//
//  SycnSceneApi.h
//  sHome
//
//  Created by shaop on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface SycnSceneApi : BaseDriveApi
-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost SceneGroup:(NSString *)scene_group answerContent:(NSString *)answer_content SceneContent:(NSString *)scene_content;
@end
