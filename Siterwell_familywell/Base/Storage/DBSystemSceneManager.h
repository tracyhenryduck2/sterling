//
//  DBSystemSceneManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBSystemSceneManager_h
#define DBSystemSceneManager_h
#import "DBManager.h"
#import "SystemSceneModel.h"
@interface DBSystemSceneManager:NSObject

+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllSystemScene:(NSString *)devTid;
- (void)insertSystemScene:(SystemSceneModel *)systemsceneModel;
- (void)insertSystemScenes:(NSArray *)systemsceneModels;
- (void)insertSystemScenesInit:(NSArray *)systemsceneModels;
- (void)updateColor:(NSString *)color withSid:(NSString *)sid withDevTid:(NSString *)DevTid;
- (void)updateSystemName:(NSString *)name withSid:(NSString *)sid withDevTid:(NSString *)DevTid;
- (void)updateSystemChoicewithSid:(NSString *)sid withDevTid:(NSString *)DevTid;
- (NSString *)queryCurrentSystemScene:(NSString *)devTid;
@end

#endif /* DBSystemSceneManager_h */
