//
//  DBSystemSceneManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBSystemSceneManager.h"

static NSString * const systemScenetable = @"sysmodle";

@implementation DBSystemSceneManager

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBSystemSceneManager* dbSystemSceneManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbSystemSceneManager = [[DBSystemSceneManager alloc] init];
        [dbSystemSceneManager createSystemSceneTable];
    });
    return dbSystemSceneManager;
}

- (void)createSystemSceneTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(name varchar(200) NOT NULL,modledesc varchar(200),choice integer default(0),sid varchar(20),devTid varchar(30),color varchar(10),primary key(sid,devTid))", systemScenetable];
    [[DBManager sharedInstanced] createTable:systemScenetable sql:sql];
    
}

#pragma mark -method
- (NSMutableArray *)queryAllSystemScene:(NSString *)devTid{
    
    
    NSMutableArray *allSystemScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where  devTid = '%@' order by sid",systemScenetable,devTid]];
        while ([rs next]) {
            SystemSceneModel *systemSceneModel = [[SystemSceneModel alloc] init];
            systemSceneModel.systemname = [rs stringForColumn:@"name"];
            systemSceneModel.choice =[NSNumber numberWithInt:[rs intForColumn:@"choice"]];
            systemSceneModel.sence_group = [rs stringForColumn:@"sid"];
            systemSceneModel.devTid = [rs stringForColumn:@"devTid"];
            systemSceneModel.color = [rs stringForColumn:@"color"];
            [allSystemScene addObject:systemSceneModel];
        }
    }];
    return allSystemScene;
}

- (NSString *)queryCurrentSystemScene:(NSString *)devTid{
    
    
   __block NSString *current_mode = @"9";
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select sid from %@ where  devTid = '%@' and choice = 1 limit 1",systemScenetable,devTid]];
        while ([rs next]) {
            
            current_mode = [rs stringForColumn:@"sid"];
            
        }
    }];
    return current_mode;
}


- (void)insertSystemScene:(SystemSceneModel *)systemsceneModel{
    
    BOOL flag_has = [self HasSystemScene:systemsceneModel.sence_group withDevTid:systemsceneModel.devTid];
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        if(flag_has == NO){
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,sid,devTid,color) VALUES ('%@','%@','%@','%@')",systemScenetable,
                             systemsceneModel.systemname,systemsceneModel.sence_group,systemsceneModel.devTid,systemsceneModel.color];
            [db executeUpdate:sql];
        }else{
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET name='%@',sid='%@',devTid='%@',color='%@' WHERE sid='%@' and devTid='%@'",systemScenetable,
                             systemsceneModel.systemname,systemsceneModel.sence_group,systemsceneModel.devTid,systemsceneModel.color,systemsceneModel.sence_group,systemsceneModel.devTid];
            [db executeUpdate:sql];
        }

    }];
}

- (void)insertSystemScenes:(NSArray *)systemsceneModels {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (SystemSceneModel *f in systemsceneModels) {
            if(![f isKindOfClass:[SystemSceneModel class]])
                continue;
            
            BOOL flag = NO;
            NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where sid = '%@' and devTid = '%@'", systemScenetable,f.sence_group,f.devTid];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                flag = YES;
            }
            if(flag == NO){
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,sid,devTid,color) VALUES ('%@','%@','%@','%@')",systemScenetable,
                                 f.systemname,f.sence_group,f.devTid,f.color];
                [db executeUpdate:sql];
            }else{
                NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET name='%@',sid='%@',devTid='%@',color='%@' WHERE sid='%@' and devTid='%@'",systemScenetable, f.systemname,f.sence_group,f.devTid,f.color,f.sence_group,f.devTid];
                [db executeUpdate:sql];
            }
        }
        [db commit];
    }];
}

- (void)insertSystemScenesInit:(NSArray *)systemsceneModels {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (SystemSceneModel *f in systemsceneModels) {
            if(![f isKindOfClass:[SystemSceneModel class]])
                continue;
            
            BOOL flag = NO;
            NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where sid = '%@' and devTid = '%@'", systemScenetable,f.sence_group,f.devTid];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                flag = YES;
            }
             [rs close];
            if(flag == NO){
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,choice,sid,devTid,color) VALUES ('%@', %d,'%@','%@','%@')",systemScenetable,
                                 f.systemname,[f.choice intValue],f.sence_group,f.devTid,f.color];
                [db executeUpdate:sql];
            }
        }
        [db commit];
    }];
}

- (void)updateColor:(NSString *)color withSid:(NSString *)sid withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set color = '%@' where sid = '%@' and devTid = '%@'", systemScenetable,color, sid, DevTid];
        [db executeUpdate:sql];
    }];
}

- (void)updateSystemName:(NSString *)name withSid:(NSString *)sid withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set name = '%@' where sid = '%@' and devTid = '%@'", systemScenetable,name, sid, DevTid];
        [db executeUpdate:sql];
    }];
}

- (void)deleteSystemScene:(NSString *)sid withDevTid:(NSString *)devTid{

    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where sid = '%@' and devTid = '%@' ", systemScenetable, sid,devTid];
         [db executeUpdate:sql];
    }];
}

- (void)updateSystemChoicewithSid:(NSString *)sid withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"update %@ set choice = 0 where devTid = '%@'", systemScenetable, DevTid];
        [db executeUpdate:sql];
        
        NSString *sql2 = [NSString stringWithFormat:@"update %@ set choice = 1 where sid = '%@' and devTid = '%@'", systemScenetable, sid, DevTid];
        [db executeUpdate:sql2];
    }];
}

- (BOOL)HasSystemScene:(NSString *)sid withDevTid:(NSString *)devTid {
    
    __block BOOL flag = NO;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where sid = '%@' and devTid = '%@'", systemScenetable,sid,devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}
@end
