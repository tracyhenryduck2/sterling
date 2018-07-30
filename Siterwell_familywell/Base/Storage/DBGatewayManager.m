//
//  DBGatewayManager.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "DBGatewayManager.h"
static NSString * const gatewaytable = @"gatewaytable";

@implementation DBGatewayManager

#pragma mark -sharesInstance
+ (instancetype)sharedInstanced {
    static DBGatewayManager* dbgatewayManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbgatewayManager = [[DBGatewayManager alloc] init];
        [dbgatewayManager createGatewayTable];
    });
    return dbgatewayManager;
}

#pragma mark -method
- (void)createGatewayTable{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(devTid varchar(30),bindKey varchar(100),ctrlKey varchar(100),deviceName varchar(100),choice integer default(0),online varchar(10),productPublicKey varchar(100),connectHost varchar(50),ssid varchar(50),binVersion varchar(50),binType varchar(50),longtitude varchar(50),latitude varchar(50),reserve varchar(100),primary key(devTid,bindKey,ctrlKey))", gatewaytable];
    [[DBManager sharedInstanced] createTable:gatewaytable sql:sql];
    
}

- (void)insertGateway:(GatewayModel *)gatewayModel{
    
    BOOL flag_has_gateway = [self HasGateway:gatewayModel.devTid];

   
        [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
             if(flag_has_gateway == NO){
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (devTid,bindKey,ctrlKey,deviceName,online,productPublicKey,connectHost,ssid,binVersion,binType) VALUES ('%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@')",gatewaytable,
                             gatewayModel.devTid,gatewayModel.bindKey,gatewayModel.ctrlKey,gatewayModel.deviceName,gatewayModel.online,gatewayModel.productPublicKey,gatewayModel.connectHost,gatewayModel.ssid,gatewayModel.binVersion,gatewayModel.binType];
            [db executeUpdate:sql];
             }else{
                 NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET devTid='%@',bindKey='%@',ctrlKey='%@',deviceName='%@',online='%@',productPublicKey='%@',connectHost='%@',ssid='%@',binVersion='%@',binType='%@' WHERE devTid='%@'",gatewaytable,
                                  gatewayModel.devTid,gatewayModel.bindKey,gatewayModel.ctrlKey,gatewayModel.deviceName,gatewayModel.online,gatewayModel.productPublicKey,gatewayModel.connectHost,gatewayModel.ssid,gatewayModel.binVersion,gatewayModel.binType,gatewayModel.devTid];
                 [db executeUpdate:sql];
             }
        }];

    
}

- (void)insertGateways:(NSArray *)gatewayModels {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (GatewayModel *gatewayModel in gatewayModels) {
            if(![gatewayModel isKindOfClass:[GatewayModel class]])
                continue;
            BOOL flag_has_gateway = NO;
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where devTid = '%@'", gatewaytable,gatewayModel.devTid];
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                flag_has_gateway = YES;
            }
            
            
            if(flag_has_gateway == NO){
                NSString *sql = [NSString stringWithFormat:@"insert into %@ (devTid,bindKey,ctrlKey,deviceName,online,productPublicKey,connectHost,ssid,binVersion,binType) VALUES ('%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@')",gatewaytable,
                                 gatewayModel.devTid,gatewayModel.bindKey,gatewayModel.ctrlKey,gatewayModel.deviceName,gatewayModel.online,gatewayModel.productPublicKey,gatewayModel.connectHost,gatewayModel.ssid,gatewayModel.binVersion,gatewayModel.binType];
                [db executeUpdate:sql];
            }else{
                NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET devTid='%@',bindKey='%@',ctrlKey='%@',deviceName='%@',online='%@',productPublicKey='%@',connectHost='%@',ssid='%@',binVersion='%@',binType='%@' WHERE devTid='%@'",gatewaytable,
                                 gatewayModel.devTid,gatewayModel.bindKey,gatewayModel.ctrlKey,gatewayModel.deviceName,gatewayModel.online,gatewayModel.productPublicKey,gatewayModel.connectHost,gatewayModel.ssid,gatewayModel.binVersion,gatewayModel.binType,gatewayModel.devTid];
                [db executeUpdate:sql];
            }
            
        }
        [db commit];
    }];
}

- (NSMutableArray *)queryAllGateway{
    
    
    NSMutableArray *allGateway = [NSMutableArray array];
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@  order by devTid",gatewaytable]];
        while ([rs next]) {
            GatewayModel * gatewayModel = [[GatewayModel alloc] init];
//            gatewayModel.IsChoice = [rs intForColumn:@"choice"];
            gatewayModel.devTid = [rs stringForColumn:@"devTid"];
            gatewayModel.bindKey = [rs stringForColumn:@"bindKey"];
            gatewayModel.ctrlKey = [rs stringForColumn:@"ctrlKey"];
            gatewayModel.deviceName = [rs stringForColumn:@"deviceName"];
            gatewayModel.productPublicKey = [rs stringForColumn:@"productPublicKey"];
            gatewayModel.connectHost = [rs stringForColumn:@"connectHost"];
            gatewayModel.ssid = [rs stringForColumn:@"ssid"];
            gatewayModel.binVersion = [rs stringForColumn:@"binVersion"];
            gatewayModel.binType = [rs stringForColumn:@"binType"];
            gatewayModel.online = [rs stringForColumn:@"online"];
            [allGateway addObject:gatewayModel];
        }
    }];
    return allGateway;
}

-(GatewayModel *)queryForChosedGateway:(NSString *)devTid{
    __block GatewayModel *gatewayModel = nil;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"select * from %@ where devTid ='%@' limit 1",gatewaytable,devTid]];
        while ([rs next]) {
            gatewayModel = [[GatewayModel alloc] init];
//            gatewayModel.IsChoice = [rs intForColumn:@"choice"];
            gatewayModel.devTid = [rs stringForColumn:@"devTid"];
            gatewayModel.bindKey = [rs stringForColumn:@"bindKey"];
            gatewayModel.ctrlKey = [rs stringForColumn:@"ctrlKey"];
            gatewayModel.deviceName = [rs stringForColumn:@"deviceName"];
            gatewayModel.productPublicKey = [rs stringForColumn:@"productPublicKey"];
            gatewayModel.connectHost = [rs stringForColumn:@"connectHost"];
            gatewayModel.ssid = [rs stringForColumn:@"ssid"];
            gatewayModel.binVersion = [rs stringForColumn:@"binVersion"];
            gatewayModel.binType = [rs stringForColumn:@"binType"];
            gatewayModel.online = [rs stringForColumn:@"online"];
        }
    }];
    return gatewayModel;
}

- (void)deleteGateway:(NSString *)devTid{
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where devTid = '%@' ", gatewaytable, devTid];
        [db executeUpdate:sql];
    }];
}

- (void)updateGatewayName:(NSString *)name withDevTid:(NSString *)DevTid {
    
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update %@ set name = '%@' where devTid = '%@'", gatewaytable,name,DevTid];
        [db executeUpdate:sql];
    }];
}


- (void)deleteGatewayTable {
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ ", gatewaytable];
        [db executeUpdate:sql];
    }];
}


- (BOOL)HasGateway:(NSString *)devTid {
    
    __block BOOL flag = NO;
    [[DBManager sharedInstanced].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@ where devTid = '%@'", gatewaytable,devTid];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            flag = YES;
        }
        [rs close];
    }];
    return flag;
}

@end
