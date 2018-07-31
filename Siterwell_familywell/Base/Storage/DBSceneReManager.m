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


- (void)insertRelation:(SceneRelationShip *)scenerelationship{

    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (sid,mid,devTid) values ('%@','%@','%@')",scenerelationshiptable,
                             scenerelationship.sid,scenerelationship.mid,scenerelationship.devTid];
            [db executeUpdate:sql];
    
        
    }];
}

- (void)insertRelations:(NSArray *)scenerelationships {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (SceneRelationShip *f in scenerelationships) {
            if(![f isKindOfClass:[SceneRelationShip class]])
                continue;
            
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (sid,mid,devTid) VALUES ('%@','%@','%@')",scenerelationshiptable,
                                 f.sid,f.mid,f.devTid];
                [db executeUpdate:sql];

        }
        [db commit];
    }];
}

-(void)deleteRelation:(NSString *)sid withDevTid:(NSString *)devTid{
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where sid = '%@' and devTid = '%@' ", scenerelationshiptable, sid,devTid];
        [db executeUpdate:sql];
    }];
}
@end
