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
            deviceModel.device_custom_name = [rs stringForColumn:@"name"];
            deviceModel.device_ID = [NSNumber numberWithInt:[rs intForColumn:@"eqid"]];
            deviceModel.device_name = [rs stringForColumn:@"equipmenttype"];
            deviceModel.devTid = [rs stringForColumn:@"devTid"];
            deviceModel.device_status = [rs stringForColumn:@"status"];
            [allDevice addObject:deviceModel];
        }
    }];
    return allDevice;
}

- (DeviceModel *)queryDeviceModel:(NSNumber *)device_ID withDevTid:(NSString *)devTid{
    
    __block DeviceModel *deviceModel = nil;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where eqid = %d and devTid = '%@' ", deviceTable,[device_ID intValue],devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while (rs.next) {
            deviceModel = [[DeviceModel alloc] init];
            deviceModel.device_custom_name = [rs stringForColumn:@"name"];
            deviceModel.device_name = [rs stringForColumn:@"equipmenttype"];
            deviceModel.device_status = [rs stringForColumn:@"status"];
            deviceModel.devTid = [rs stringForColumn:@"devTid"];
            deviceModel.device_ID = [NSNumber numberWithInt:[rs intForColumn:@"eqid"]];
        }
    }];
    return deviceModel;
}


- (void)insertDevice:(DeviceModel *)deviceModel{

   BOOL flag_has_device = [self HasDevice:deviceModel.device_ID withDevTid:deviceModel.devTid];
    NSLog(@"是否含有该子设备%d",flag_has_device);

        [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
                if(flag_has_device == NO){
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,eqid,equipmenttype,status,devTid) VALUES ('%@', %d,'%@','%@','%@')",deviceTable,
                             deviceModel.device_custom_name,[deviceModel.device_ID intValue] ,deviceModel.device_name,deviceModel.device_status,deviceModel.devTid];
            [db executeUpdate:sql];
                }else{
                    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET name='%@',eqid=%d,equipmenttype='%@',status='%@',devTid='%@' WHERE eqid=%d and devTid='%@'",deviceTable, deviceModel.device_custom_name,[deviceModel.device_ID intValue] ,deviceModel.device_name,deviceModel.device_status,deviceModel.devTid,[deviceModel.device_ID intValue],deviceModel.devTid];
                    [db executeUpdate:sql];
                }
        }];

}

- (void)insertDevices:(NSArray *)deviceModels {
 
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (DeviceModel *f in deviceModels) {
            if(![f isKindOfClass:[DeviceModel class]])
                continue;
            BOOL flag = NO;
            NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where eqid = %d and devTid = '%@'", deviceTable,[f.device_ID intValue],f.devTid];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                flag = YES;
            }
            [rs close];
            if(flag == NO){
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,eqid,equipmenttype,status,devTid) VALUES ('%@', %d,'%@','%@','%@')",deviceTable,
                                 f.device_custom_name,[f.device_ID intValue] ,f.device_name,f.device_status,f.devTid];
                [db executeUpdate:sql];
            }else{
                NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET name='%@',eqid=%d,equipmenttype='%@',status='%@',devTid='%@' WHERE eqid=%d and devTid='%@'",deviceTable, f.device_custom_name,[f.device_ID intValue] ,f.device_name,f.device_status,f.devTid,[f.device_ID intValue],f.devTid];
                [db executeUpdate:sql];
            }
        }
        [db commit];
    }];
}

- (void)deleteDevice:(NSNumber *)eqid withDevTid:(NSString *)devTid{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where eqid = %d and devTid = '%@' ", deviceTable, [eqid intValue],devTid];
        [db executeUpdate:sql];
    }];
}


- (BOOL)HasDevice:(NSNumber *)eqid withDevTid:(NSString *)devTid {

    __block BOOL flag = NO;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where eqid = %d and devTid = '%@'", deviceTable,[eqid intValue],devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}


@end
