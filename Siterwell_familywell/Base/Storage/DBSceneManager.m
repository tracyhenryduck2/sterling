//
//  DBSceneManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBSceneManager.h"

static NSString * const scenetable = @"scenetable";

@implementation DBSceneManager

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBSceneManager* dbSceneManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbSceneManager = [[DBSceneManager alloc] init];
        [dbSceneManager createSceneTable];
    });
    return dbSceneManager;
}

#pragma mark -method
- (void)createSceneTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(name varchar(200) not null,code varchar(100),desc varchar(100),mid varchar(40),devTid varchar(30),primary key(mid,devTid))", scenetable];
    [[DBManager sharedInstanced] createTable:scenetable sql:sql];
    
}

- (NSMutableArray *)queryAllScenewithDevTid:(NSString *)devTid{
    
    
    NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid = '%@' order by mid",scenetable,devTid]];
        while ([rs next]) {
            SceneModel *sceneModel = [[SceneModel alloc] init];
            sceneModel.scene_name = [rs stringForColumn:@"name"];
            sceneModel.scene_content = [rs stringForColumn:@"code"];
            sceneModel.scene_type = [rs stringForColumn:@"mid"];
            sceneModel.devTid = [rs stringForColumn:@"devTid"];
            [allScene addObject:sceneModel];
        }
    }];
    return allScene;
}


- (SceneModel *)querySceneModel:(NSString *)mid withDevTid:(NSString *)devTid{
    
    __block SceneModel *scenemodel = nil;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where mid = '%@' and devTid = '%@' ", scenetable,mid,devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            scenemodel = [[SceneModel alloc] init];
            scenemodel.scene_type = [rs stringForColumn:@"mid"];
            scenemodel.scene_content = [rs stringForColumn:@"code"];
            scenemodel.scene_name = [rs stringForColumn:@"name"];
            scenemodel.devTid = [rs stringForColumn:@"devTid"];
          
        }
    }];
    return scenemodel;
}

@end
