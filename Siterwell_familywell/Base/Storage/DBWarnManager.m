//
//  DBWarnManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/11.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBWarnManager.h"

static NSString * const warninfotable = @"noticetable";

@implementation DBWarnManager 

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBWarnManager* dbwarnmanager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbwarnmanager = [[DBWarnManager alloc] init];
        [dbwarnmanager createGatewayTable];
    });
    return dbwarnmanager;
}


#pragma mark -method
- (void)createGatewayTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(warnid integer,type varchar(5),mid varchar(40),eqid integer default(0),equipmenttype varchar(10),eqstatus varchar(10),activitytime date,desc varchar(100),devTid varchar(30),name varchar(150),primary key(warnid,devTid))", warninfotable];
    [[DBManager sharedInstanced] createTable:warninfotable sql:sql];
    
}

- (void)insertDevice:(WarnModel *) warnModel{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (warnid,type,mid,eqid,equipmenttype,eqstatus,activitytime,devTid) VALUES ('%d','%@','%@','%d','%@','%@','%@','%@')",warninfotable,(int)warnModel.warnid,
                         warnModel.type,warnModel.mid,(int)warnModel.eqid,warnModel.deviceName,warnModel.deviceStatus,warnModel.time,warnModel.devTid];
        [db executeUpdate:sql];
    }];
}

- (void)insertDevices:(NSArray *)warnModels {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (WarnModel *f in warnModels) {
            if(![f isKindOfClass:[WarnModel class]])
                continue;
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (warnid,type,mid,eqid,equipmenttype,eqstatus,activitytime,devTid) VALUES ('%d','%@','%@','%d','%@','%@','%@','%@')",warninfotable,(int)f.warnid,
                             f.type,f.mid,(int)f.eqid,f.deviceName,f.deviceStatus,f.time,f.devTid];
            [db executeUpdate:sql];
        }
        [db commit];
    }];
}

- (NSMutableArray *)queryAllWarnInfo:(NSString *)devTid{
    
    
    NSMutableArray *allDevice = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid = '%@' order by warnid",warninfotable,devTid]];
        while ([rs next]) {
            WarnModel *deviceModel = [[WarnModel alloc] init];
            deviceModel.warnid = [rs intForColumn:@"warnid"];
            deviceModel.eqid = [rs intForColumn:@"eqid"];
            deviceModel.mid = [rs stringForColumn:@"mid"];
            deviceModel.devTid = [rs stringForColumn:@"devTid"];
            deviceModel.deviceName = [rs stringForColumn:@"equipmenttype"];
            deviceModel.deviceStatus = [rs stringForColumn:@"eqstatus"];
            deviceModel.time = [rs dateForColumn:@"activitytime"];
            deviceModel.type = [rs stringForColumn:@"type"];
            [allDevice addObject:deviceModel];
        }
    }];
    return allDevice;
}

@end
