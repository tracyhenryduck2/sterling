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
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(name varchar(200) NOT NULL,modledesc varchar(200),choice integer default(0),sid integer default(0),devTid varchar(30),color varchar(10),primary key(sid,devTid))", systemScenetable];
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
            systemSceneModel.sence_group = [NSNumber numberWithInt:[rs intForColumn:@"sid"]];
            systemSceneModel.devTid = [rs stringForColumn:@"devTid"];
            systemSceneModel.color = [rs stringForColumn:@"color"];
            [allSystemScene addObject:systemSceneModel];
        }
    }];
    return allSystemScene;
}

- (NSMutableArray *)queryAllSystemSceneId:(NSString *)devTid{
    
    
    NSMutableArray *allSystemScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where  devTid = '%@' order by sid",systemScenetable,devTid]];
        while ([rs next]) {
            NSNumber * sence_group = [NSNumber numberWithInt:[rs intForColumn:@"sid"]];
            [allSystemScene addObject:sence_group];
        }
    }];
    return allSystemScene;
}


- (NSNumber *)queryCurrentSystemScene:(NSString *)devTid{
    
    
   __block NSNumber *current_mode = @9;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select sid from %@ where  devTid = '%@' and choice = 1 limit 1",systemScenetable,devTid]];
        while ([rs next]) {
            
            current_mode = [NSNumber numberWithInt:[rs intForColumn:@"sid"]];
            
        }
    }];
    return current_mode;
}

- (SystemSceneModel *)queryCurrentSystemScene2:(NSString *)devTid{
    
    
    __block SystemSceneModel *systemSceneModel = nil;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where  devTid = '%@' and choice = 1 limit 1",systemScenetable,devTid]];
        while ([rs next]) {
            systemSceneModel = [[SystemSceneModel alloc] init];
            systemSceneModel.systemname = [rs stringForColumn:@"name"];
            systemSceneModel.choice =[NSNumber numberWithInt:[rs intForColumn:@"choice"]];
            systemSceneModel.sence_group = [NSNumber numberWithInt:[rs intForColumn:@"sid"]];
            systemSceneModel.devTid = [rs stringForColumn:@"devTid"];
            systemSceneModel.color = [rs stringForColumn:@"color"];
            
        }
    }];
    return systemSceneModel;
}

- (SystemSceneModel *)querySystemScene:(NSNumber *)sid withDevTid:(NSString *)devTid{
    
    
    __block SystemSceneModel *systemSceneModel;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where  devTid = '%@' and sid = %@ order by sid",systemScenetable,devTid,sid]];
        while ([rs next]) {
            systemSceneModel = [[SystemSceneModel alloc] init];
            systemSceneModel.systemname = [rs stringForColumn:@"name"];
            systemSceneModel.choice =[NSNumber numberWithInt:[rs intForColumn:@"choice"]];
            systemSceneModel.sence_group = [NSNumber numberWithInt:[rs intForColumn:@"sid"]];
            systemSceneModel.devTid = [rs stringForColumn:@"devTid"];
            systemSceneModel.color = [rs stringForColumn:@"color"];

        }
    }];
    return systemSceneModel;
}


- (void)insertSystemScene:(SystemSceneModel *)systemsceneModel{
    
    BOOL flag_has = [self HasSystemScene:systemsceneModel.sence_group withDevTid:systemsceneModel.devTid];
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        if(flag_has == NO){
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,sid,devTid,color) VALUES ('%@',%d,'%@','%@')",systemScenetable,
                             systemsceneModel.systemname,[systemsceneModel.sence_group intValue],systemsceneModel.devTid,systemsceneModel.color];
            [db executeUpdate:sql];
        }else{
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET name='%@',sid=%d,devTid='%@',color='%@' WHERE sid=%d and devTid='%@'",systemScenetable,
                             systemsceneModel.systemname,[systemsceneModel.sence_group intValue],systemsceneModel.devTid,systemsceneModel.color,[systemsceneModel.sence_group intValue],systemsceneModel.devTid];
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
            NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where sid = %d and devTid = '%@'", systemScenetable,[f.sence_group intValue],f.devTid];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                flag = YES;
            }
            if(flag == NO){
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,sid,devTid,color) VALUES ('%@',%d,'%@','%@')",systemScenetable,
                                 f.systemname,[f.sence_group intValue],f.devTid,f.color];
                [db executeUpdate:sql];
            }else{
                NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET name='%@',sid=%d,devTid='%@',color='%@' WHERE sid=%d and devTid='%@'",systemScenetable, f.systemname,[f.sence_group intValue],f.devTid,f.color,[f.sence_group intValue],f.devTid];
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
            NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where sid = %d and devTid = '%@'", systemScenetable,[f.sence_group intValue],f.devTid];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                flag = YES;
            }
             [rs close];
            if(flag == NO){
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,choice,sid,devTid,color) VALUES ('%@', %d,%d,'%@','%@')",systemScenetable,
                                 f.systemname,[f.choice intValue],[f.sence_group intValue],f.devTid,f.color];
                [db executeUpdate:sql];
            }
        }
        [db commit];
    }];
}

- (void)updateColor:(NSString *)color withSid:(NSNumber *)sid withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set color = '%@' where sid = %d and devTid = '%@'", systemScenetable,color, [sid intValue], DevTid];
        [db executeUpdate:sql];
    }];
}

- (void)updateSystemName:(NSString *)name withSid:(NSNumber *)sid withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set name = '%@' where sid = %d and devTid = '%@'", systemScenetable,name, [sid intValue], DevTid];
        [db executeUpdate:sql];
    }];
}

- (void)deleteSystemScene:(NSNumber *)sid withDevTid:(NSString *)devTid{

    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where sid = %d and devTid = '%@' ", systemScenetable, [sid intValue],devTid];
         [db executeUpdate:sql];
    }];
}

- (void)updateSystemChoicewithSid:(NSNumber *)sid withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"update %@ set choice = 0 where devTid = '%@'", systemScenetable, DevTid];
        [db executeUpdate:sql];
        
        NSString *sql2 = [NSString stringWithFormat:@"update %@ set choice = 1 where sid = %d and devTid = '%@'", systemScenetable, [sid intValue], DevTid];
        [db executeUpdate:sql2];
    }];
}

- (BOOL)HasSystemScene:(NSNumber *)sid withDevTid:(NSString *)devTid {
    
    __block BOOL flag = NO;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where sid = %d and devTid = '%@'", systemScenetable,[sid intValue],devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}
@end
