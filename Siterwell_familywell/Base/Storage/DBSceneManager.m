//
//  DBSceneManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBSceneManager.h"
#import "DBSceneReManager.h"

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
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(name varchar(200) not null,code varchar(100),desc varchar(100),mid integer default(0),devTid varchar(30),primary key(mid,devTid))", scenetable];
    [[DBManager sharedInstanced] createTable:scenetable sql:sql];
    
}

- (NSMutableArray *)queryAllScenewithDevTid:(NSString *)devTid{
    
    
   __block NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid = '%@' order by mid",scenetable,devTid]];
        while ([rs next]) {
            SceneModel *sceneModel = [[SceneModel alloc] init];
            sceneModel.scene_name = [rs stringForColumn:@"name"];
            sceneModel.scene_content = [rs stringForColumn:@"code"];
            sceneModel.scene_type = [NSNumber numberWithInt:[rs intForColumn:@"mid"]];
            sceneModel.devTid = [rs stringForColumn:@"devTid"];
            [allScene addObject:sceneModel];
        }
    }];
    return allScene;
}

-(NSMutableArray *)queryAllSysceneScene:(NSNumber *)sid withDevTid:(NSString *)devTid{
    __block NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select b.* from %@ a inner join %@ b on a.mid = b.mid where a.sid = %d and a.devTid = '%@'",scenerelationshiptable,scenetable,[sid intValue],devTid]];
        while ([rs next]) {
            SceneModel *sceneModel = [[SceneModel alloc] init];
            sceneModel.scene_name = [rs stringForColumn:@"name"];
            sceneModel.scene_content = [rs stringForColumn:@"code"];
            sceneModel.scene_type = [NSNumber numberWithInt:[rs intForColumn:@"mid"]];
            sceneModel.devTid = [rs stringForColumn:@"devTid"];
            [allScene addObject:sceneModel];
        }
    }];
    return allScene;
}

- (SceneModel *)querySceneModel:(NSNumber *)mid withDevTid:(NSString *)devTid{
    
    __block SceneModel *scenemodel = nil;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where mid = %d and devTid = '%@' ", scenetable,[mid intValue],devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            scenemodel = [[SceneModel alloc] init];
            scenemodel.scene_type =[NSNumber numberWithInt:[rs intForColumn:@"mid"]];
            scenemodel.scene_content = [rs stringForColumn:@"code"];
            scenemodel.scene_name = [rs stringForColumn:@"name"];
            scenemodel.devTid = [rs stringForColumn:@"devTid"];
          
        }
    }];
    return scenemodel;
}

- (void)insertScene:(SceneModel *)sceneModel{
    
    BOOL flag_has = [self HasScene:sceneModel.scene_type withDevTid:sceneModel.devTid];
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        if(flag_has == NO){
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,code,devTid,mid) VALUES ('%@','%@','%@','%@')",scenetable,
                             sceneModel.scene_name,sceneModel.scene_content,sceneModel.devTid,sceneModel.scene_type];
            [db executeUpdate:sql];
        }else{
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET name='%@',code='%@',devTid='%@',mid='%@' WHERE mid='%@' and devTid='%@'",scenetable,
                             sceneModel.scene_name,sceneModel.scene_content,sceneModel.devTid,sceneModel.scene_type,sceneModel.scene_type,sceneModel.devTid];
            [db executeUpdate:sql];
        }
        
    }];
}

- (BOOL)HasScene:(NSNumber *)mid withDevTid:(NSString *)devTid {
    
    __block BOOL flag = NO;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where mid = %d and devTid = '%@'", scenetable,[mid intValue],devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}

- (void)deleteScene:(NSNumber *)mid withDevTid:(NSString *)devTid{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where mid = %d and devTid = '%@' ", scenetable, [mid intValue],devTid];
        [db executeUpdate:sql];
    }];
}
@end
