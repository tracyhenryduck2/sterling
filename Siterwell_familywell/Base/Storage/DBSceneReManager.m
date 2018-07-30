//
//  DBSceneReManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBSceneReManager.h"


static NSString * const scenerelationshiptable = @"scenerelationshiptable";

@implementation DBSceneReManager

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBSceneReManager* dbSceneReManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbSceneReManager = [[DBSceneReManager alloc] init];
        [dbSceneReManager createRelationShipTable];
    });
    return dbSceneReManager;
}

#pragma mark -method
- (void)createRelationShipTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(sid varchar(40),mid varchar(40),devTid varchar(30),primary key(sid,mid,devTid))", scenerelationshiptable];
    [[DBManager sharedInstanced] createTable:scenerelationshiptable sql:sql];
    
}

- (NSMutableArray *)queryAllGS584RelationShipwithDevTid:(NSString *)devTid{
    
    
    NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid = '%@'",scenerelationshiptable,devTid]];
        while ([rs next]) {
            SceneRelationShip *gs584RelationShip = [[SceneRelationShip alloc] init];
            gs584RelationShip.sid = [rs stringForColumn:@"sid"];
            gs584RelationShip.mid = [rs stringForColumn:@"mid"];
            gs584RelationShip.devTid = [rs stringForColumn:@"devTid"];
            [allScene addObject:gs584RelationShip];
        }
    }];
    return allScene;
}


- (NSMutableArray *)queryGS584RelationShip:(NSString *)sid withDevTid:(NSString *)devTid{
    
    
    NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where sid ='%@' and devTid = '%@'",scenerelationshiptable,sid,devTid]];
        while ([rs next]) {
            SceneRelationShip *gs584RelationShip = [[SceneRelationShip alloc] init];
            gs584RelationShip.sid = [rs stringForColumn:@"sid"];
            gs584RelationShip.mid = [rs stringForColumn:@"mid"];
            gs584RelationShip.devTid = [rs stringForColumn:@"devTid"];
            [allScene addObject:gs584RelationShip];
        }
    }];
    return allScene;
}

@end
