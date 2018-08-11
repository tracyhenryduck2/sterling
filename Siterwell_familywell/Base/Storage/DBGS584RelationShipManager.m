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
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(sid integer default(0),eqid integer default(0),action integer default(0),delay integer default(0),devTid varchar(30),primary key(sid,eqid,action,devTid))", gs584relationshiptable];
    [[DBManager sharedInstanced] createTable:gs584relationshiptable sql:sql];
    
}

- (NSMutableArray *)queryAllGS584RelationShipwithDevTid:(NSString *)devTid withSid:(NSNumber *)sid{
    
    
    NSMutableArray *allScene = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid = '%@' and sid = %d",gs584relationshiptable,devTid,[sid intValue]]];
        while ([rs next]) {
            GS584RelationShip *gs584RelationShip = [[GS584RelationShip alloc] init];
            gs584RelationShip.sid = [NSNumber numberWithInt:[rs intForColumn:@"sid"]];
            gs584RelationShip.action = [NSNumber numberWithInt:[rs intForColumn:@"action"]];
            gs584RelationShip.eqid = [NSNumber numberWithInt:[rs intForColumn:@"eqid"]];
            gs584RelationShip.delay = [rs intForColumn:@"delay"];
            gs584RelationShip.devTid = [rs stringForColumn:@"devTid"];
            [allScene addObject:gs584RelationShip];
        }
    }];
    return allScene;
}

- (void)insertGS584Relation:(GS584RelationShip *)gs584relationship{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (sid,action,eqid,delay,devTid) values (%d,%d,%d,%ld,'%@')",gs584relationshiptable,
                         [gs584relationship.sid intValue],[gs584relationship.action intValue],[gs584relationship.eqid intValue],gs584relationship.delay,gs584relationship.devTid];
        [db executeUpdate:sql];
        
        
    }];
}

- (void)insertGS584Relations:(NSArray *)gs584relationships{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (GS584RelationShip *f in gs584relationships) {
            if(![f isKindOfClass:[GS584RelationShip class]])
                continue;
            
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (sid,action,eqid,delay,devTid) values (%d,%d,%d,%ld,'%@')",gs584relationshiptable,
                             [f.sid intValue],[f.action intValue],[f.eqid intValue],f.delay,f.devTid];
            [db executeUpdate:sql];
            
        }
        [db commit];
        
    }];
}

-(void)deleteRelation:(NSNumber *)sid withDevTid:(NSString *)devTid{
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where sid = %d and devTid = '%@' ", gs584relationshiptable, [sid intValue],devTid];
        [db executeUpdate:sql];
    }];
}

@end
