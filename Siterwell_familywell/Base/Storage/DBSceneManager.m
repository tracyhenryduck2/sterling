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
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(name varchar(200) not null,code varchar(100),desc varchar(100),sid varchar(40),mid varchar(40),devTid varchar(30),primary key(mid,sid,devTid))", scenetable];
    [[DBManager sharedInstanced] createTable:scenetable sql:sql];
    
}

- (NSMutableArray *)queryAllScene:(NSString *)sid withDevTid:(NSString *)devTid{
    
    
    NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where sid ='%@' and devTid = '%@' order by mid",scenetable,sid,devTid]];
        while ([rs next]) {
            SceneModel *sceneModel = [[SceneModel alloc] init];
            sceneModel.scenename = [rs stringForColumn:@"name"];
            sceneModel.code = [rs stringForColumn:@"code"];
            sceneModel.mid = [rs stringForColumn:@"mid"];
            sceneModel.sid = [rs stringForColumn:@"sid"];
            sceneModel.devTid = [rs stringForColumn:@"devTid"];
            [allScene addObject:sceneModel];
        }
    }];
    return allScene;
}

@end
