//
//  DBSceneReManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBSceneReManager_h
#define DBSceneReManager_h
#import "DBManager.h"
#import "SceneRelationShip.h"

static NSString * const scenerelationshiptable = @"scenerelationshiptable";

@interface DBSceneReManager:NSObject
+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllGS584RelationShipwithDevTid:(NSString *)devTid;
- (NSMutableArray *)queryGS584RelationShip:(NSNumber *)sid withDevTid:(NSString *)devTid;
- (NSMutableArray *)querymid:(NSNumber *)sid withDevTid:(NSString *)devTid;
- (void)insertRelation:(SceneRelationShip *)scenerelationship;
- (void)insertRelations:(NSArray *)scenerelationships;
- (void)deleteRelation:(NSNumber *)sid withDevTid:(NSString *)devTid;
@end

#endif /* DBSceneReManager_h */
