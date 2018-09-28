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
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(timerid integer,enable integer,sid varchar(5),week varchar(5),hour varchar(5),min varchar(5),code varchar(20),devTid varchar(30),primary key(timerid,devTid))", timertable];
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
            timermodel.devTid = [rs stringForColumn:@"devTid"];
            [alltimers addObject:timermodel];
        }
    }];
    return alltimers;
}

- (void)deleteTimer:(NSString *)timerid withDevTid:(NSString *)devTid{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where timerid = '%@' and devTid = '%@' ", timertable,timerid, devTid];
        [db executeUpdate:sql];
    }];
}

- (void)updateTimerEnable:(NSNumber *)enable withTimerid:(NSNumber *)timerid withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set enable = %d where timerid = %d and devTid = '%@'", timertable,[enable intValue],[timerid intValue],DevTid];
        [db executeUpdate:sql];
    }];
}

@end
