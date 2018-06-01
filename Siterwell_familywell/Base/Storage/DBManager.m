//
//  DBManager.m
//  Siterwell_familywell
//
//  Created by iMac on 2018/4/5.
//  Copyright © 2018年 iMac. All rights reserved.
//
#import "DBManager.h"

#define EC_DB_NAME @"im_familywell.db"

@interface DBManager()

@end

@implementation DBManager

+(instancetype)sharedInstanced {
    static DBManager* dbManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dbManager = [[DBManager alloc] init];
    });
    return dbManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        self.isOpenDebugLog = YES;
#else
        self.isOpenDebugLog = NO;
#endif
    }
    return self;
}

- (BOOL)isIsOpenDebugLog {
#ifdef DEBUG
    return _isOpenDebugLog;
#else
    return NO;
#endif
}

- (void)openDB:(NSString *)dbName{
    if (dbName.length==0) {
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:EC_DB_NAME];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
}

- (void)createTable:(NSString *)tableName sql:(NSString *)createSql {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL isExist = [db tableExists:tableName];
        if (!isExist) {
            BOOL createSuccess = [db executeUpdate:createSql];
            NSLog(@"createTable success = %d", createSuccess);
        }
    }];
}

- (void)alertTableColumn:(NSString *)column inTable:(NSString *)tableName{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if(![db columnExists:column inTableWithName:tableName]){
            [db executeUpdate:[NSString stringWithFormat:@"alter table %@ add %@ TEXT", tableName, column]];
        }
    }];
}

@end
