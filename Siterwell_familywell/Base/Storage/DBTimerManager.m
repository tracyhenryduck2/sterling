//
//  DBGatewayManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBTimerManager.h"
static  NSString * const timertable = @"timertable";

@implementation DBTimerManager

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBTimerManager* dbtimerManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbtimerManager = [[DBTimerManager alloc] init];
        [dbtimerManager createTimerTable];
    });
    return dbtimerManager;
}

#pragma mark -method
- (void)createTimerTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(timerid integer,enable integer,sid integer,week varchar(5),hour varchar(5),min varchar(5),code varchar(20),devTid varchar(30),primary key(timerid,devTid))", timertable];
    [[DBManager sharedInstanced] createTable:timertable sql:sql];
    
}

- (NSMutableArray *)queryAllTimers:(NSString *)devTid{
    
    
    NSMutableArray *alltimers= [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid = '%@' order by timerid",timertable,devTid]];
        while ([rs next]) {
            TimerModel * timermodel = [[TimerModel alloc] init];
            timermodel.enable = [NSNumber numberWithInt:[rs intForColumn:@"enable"]];
            timermodel.timerid = [NSNumber numberWithInt:[rs intForColumn:@"timerid"]];
            timermodel.sid =[NSNumber numberWithInt:[rs intForColumn:@"sid"]];
            timermodel.week = [rs stringForColumn:@"week"];
            timermodel.hour = [rs stringForColumn:@"hour"];
            timermodel.min = [rs stringForColumn:@"min"];
            timermodel.time = [rs stringForColumn:@"code"];
            timermodel.devTid = [rs stringForColumn:@"devTid"];
            [alltimers addObject:timermodel];
        }
    }];
    return alltimers;
}

- (TimerModel *)queryTimer:(NSNumber *)timerid withDevTid:(NSString *)devTid{
    
    
   __block TimerModel * timermodel = nil;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid = '%@' order by timerid",timertable,devTid]];
        while ([rs next]) {
            timermodel = [[TimerModel alloc] init];
            timermodel.enable = [NSNumber numberWithInt:[rs intForColumn:@"enable"]];
            timermodel.timerid = [NSNumber numberWithInt:[rs intForColumn:@"timerid"]];
            timermodel.sid =[NSNumber numberWithInt:[rs intForColumn:@"sid"]];
            timermodel.week = [rs stringForColumn:@"week"];
            timermodel.hour = [rs stringForColumn:@"hour"];
            timermodel.min = [rs stringForColumn:@"min"];
            timermodel.time = [rs stringForColumn:@"code"];
            timermodel.devTid = [rs stringForColumn:@"devTid"];
        }
    }];
    return timermodel;
}


- (void)deleteTimer:(NSNumber *)timerid withDevTid:(NSString *)devTid{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where timerid = %d and devTid = '%@' ", timertable,[timerid intValue], devTid];
        [db executeUpdate:sql];
    }];
}

- (void)updateTimerEnable:(NSNumber *)enable withTimerid:(NSNumber *)timerid withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set enable = %d where timerid = %d and devTid = '%@'", timertable,[enable intValue],[timerid intValue],DevTid];
        [db executeUpdate:sql];
    }];
}

- (BOOL)HasTimer:(NSNumber *)timerid withDevTid:(NSString *)devTid {
    
    __block BOOL flag = NO;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where timerid = %d and devTid = '%@'", timertable,[timerid intValue],devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}


- (void)insertTimer:(TimerModel *)timerModel{
    
    BOOL flag_has = [self HasTimer:timerModel.timerid withDevTid:timerModel.devTid];
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        if(flag_has == NO){
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (timerid,enable,sid,week,hour,min,code,devTid) VALUES (%@,%@,%@,'%@','%@','%@','%@','%@')",timertable,timerModel.timerid,timerModel.enable,timerModel.sid,timerModel.week,timerModel.hour,timerModel.min,timerModel.time,timerModel.devTid];
            [db executeUpdate:sql];
        }else{
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET timerid=%@,enable=%@,sid=%@,week='%@',hour='%@',min='%@',code='%@',devTid='%@' WHERE timerid=%@ and devTid='%@'",timertable,
                             timerModel.timerid,timerModel.enable,timerModel.sid,timerModel.week,timerModel.hour,timerModel.min,timerModel.time,timerModel.devTid,timerModel.timerid,timerModel.devTid];
            [db executeUpdate:sql];
        }
        
    }];
}
@end
