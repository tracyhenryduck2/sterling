//
//  DBVideoManager.m
//  Siterwell_familywell
//
//  Created by Henry on 2019/1/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#import "DBVideoManager.h"




@implementation DBVideoManager

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBVideoManager* dbVideoManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbVideoManager = [[DBVideoManager alloc] init];
        [dbVideoManager createVideoTable];
    });
    return dbVideoManager;
}

#pragma mark -method
- (void)createVideoTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(name varchar(100),img varchar(100),devid varchar(30),serve varchar(100),primary key(devid))", videotable];
    [[DBManager sharedInstanced] createTable:videotable sql:sql];
    
}

- (NSMutableArray *)queryAllVideo{
    
    
    NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ ",videotable]];
        while ([rs next]) {
            VideoModel *videoModel = [[VideoModel alloc] init];
            videoModel.devid = [rs stringForColumn:@"devid"];
            videoModel.name = [rs stringForColumn:@"name"];
            videoModel.img = [rs stringForColumn:@"img"];
            [allScene addObject:videoModel];
        }
    }];
    return allScene;
}

- (NSMutableArray *)queryAllVideoWithoutImg{
    
    
    NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ ",videotable]];
        while ([rs next]) {
            VideoModel *videoModel = [[VideoModel alloc] init];
            videoModel.devid = [rs stringForColumn:@"devid"];
            videoModel.name = [rs stringForColumn:@"name"];
            [allScene addObject:videoModel];
        }
    }];
    return allScene;
}



- (void)insertVideo:(VideoModel *)videoModel{
    
    BOOL flag_has_gateway = [self HasVideo:videoModel.devid];
    
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        if(flag_has_gateway == NO){
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (devid,name) VALUES ('%@', '%@')",videotable,
                             videoModel.devid,videoModel.name];
            [db executeUpdate:sql];
        }else{
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET devid='%@',name='%@' WHERE devid='%@'",videotable,
                             videoModel.devid,videoModel.name,videoModel.devid];
            [db executeUpdate:sql];
        }
    }];
    
    
}


-(void)deleteVideo:(NSString *)devTid{
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where devid = '%@' ", videotable,devTid];
        [db executeUpdate:sql];
    }];
}


- (BOOL)HasVideo:(NSString *)devTid {
    
    __block BOOL flag = NO;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where  devid = '%@'", videotable,devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}

@end
