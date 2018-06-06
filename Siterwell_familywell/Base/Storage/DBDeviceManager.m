//
//  DBDeviceManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/1.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBDeviceManager.h"

static NSString *deviceTable = @"device_table";

@implementation DBDeviceManager

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBDeviceManager* dbManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbManager = [[DBDeviceManager alloc] init];
        [dbManager createDeviceTable];
    });
    return dbManager;
}

#pragma mark -method
- (void)createDeviceTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(name varchar(200) NOT NULL, eqid integer default(0),equipmenttype varchar(20),status varchar(20),equipmentdesc varchar(200),packageid integer default (0),sort integer,devTid varchar(30),primary key(eqid,devTid))", deviceTable];
    [[DBManager sharedInstanced] createTable:deviceTable sql:sql];
 
}

- (NSMutableArray *)queryAllDevice:(NSString *)devTid{

    
    NSMutableArray *allDevice = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where packageid = 0 and devTid = '%@' group by eqid order by sort,eqid",deviceTable,devTid]];
        while ([rs next]) {
            DeviceModel *deviceModel = [[DeviceModel alloc] init];
            deviceModel.devicename = [rs stringForColumn:@"name"];
            deviceModel.eqid = [rs intForColumn:@"eqid"];
            deviceModel.devicetype = [rs stringForColumn:@"equipmenttype"];
            deviceModel.devTid = [rs stringForColumn:@"devTid"];
            deviceModel.devicestatus = [rs stringForColumn:@"status"];
            [allDevice addObject:deviceModel];
        }
    }];
    return allDevice;
}

- (void)insertDevice:(DeviceModel *)deviceModel{

    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,eqid,equipment,equipmenttype,status,devTid) VALUES ('%@', %d,'%@','%@','%@')",deviceTable,
                         deviceModel.devicename,(int)deviceModel.eqid,deviceModel.devicetype,deviceModel.devicestatus,deviceModel.devTid];
        [db executeUpdate:sql];
    }];
}

- (void)insertDevices:(NSArray *)deviceModels {
 
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (DeviceModel *f in deviceModels) {
            if(![f isKindOfClass:[DeviceModel class]])
                continue;
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,eqid,equipment,equipmenttype,status,devTid) VALUES ('%@', %d,'%@','%@','%@')",deviceTable,
                             f.devicename,(int)f.eqid,f.devicetype,f.devicestatus,f.devTid];
            BOOL isSuccess = [db executeUpdate:sql];
            NSLog(@"insertDevices : isSuccess=%d",isSuccess);
        }
        [db commit];
    }];
}

- (void)deleteDevice:(NSString *)eqid withDevTid:(NSString *)devTid{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where sid = '%@' and devTid = '%@' ", deviceTable, eqid,devTid];
        [db executeUpdate:sql];
    }];
}

@end
