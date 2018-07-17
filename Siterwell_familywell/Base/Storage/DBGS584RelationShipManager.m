//
//  DBGS584RelationShipManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBGS584RelationShipManager.h"

static NSString * const gs584relationshiptable = @"gs584relationtable";

@implementation DBGS584RelationShipManager

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBGS584RelationShipManager* dbgs584RelationShipManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbgs584RelationShipManager = [[DBGS584RelationShipManager alloc] init];
        [dbgs584RelationShipManager createGS584RelationShipTable];
    });
    return dbgs584RelationShipManager;
}

#pragma mark -method
- (void)createGS584RelationShipTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(sid varchar(40),eqid integer default(0),action varchar(40),delay integer default(0),devTid varchar(30),primary key(sid,eqid,action,devTid))", gs584relationshiptable];
    [[DBManager sharedInstanced] createTable:gs584relationshiptable sql:sql];
    
}

- (NSMutableArray *)queryAllGS584RelationShipwithDevTid:(NSString *)devTid withSid:(NSString *)sid{
    
    
    NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid = '%@' and sid = '%@'",gs584relationshiptable,devTid,sid]];
        while ([rs next]) {
            GS584RelationShip *gs584RelationShip = [[GS584RelationShip alloc] init];
            gs584RelationShip.sid = [rs stringForColumn:@"sid"];
            gs584RelationShip.action = [rs stringForColumn:@"action"];
            gs584RelationShip.eqid = [rs intForColumn:@"eqid"];
            gs584RelationShip.delay = [rs intForColumn:@"delay"];
            gs584RelationShip.devTid = [rs stringForColumn:@"devTid"];
            [allScene addObject:gs584RelationShip];
        }
    }];
    return allScene;
}

@end
