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
- (void)updateColor:(NSString *)color withSid:(NSNumber *)sid withDevTid:(NSString *)DevTid;
- (void)updateSystemName:(NSString *)name withSid:(NSNumber *)sid withDevTid:(NSString *)DevTid;
- (void)updateSystemChoicewithSid:(NSNumber *)sid withDevTid:(NSString *)DevTid;
- (NSNumber *)queryCurrentSystemScene:(NSString *)devTid;
- (void)deleteSystemScene:(NSNumber *)sid withDevTid:(NSString *)devTid;
@end

#endif /* DBSystemSceneManager_h */
