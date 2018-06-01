//
//  DBManager.h
//  Siterwell_familywell
//
//  Created by iMac on 2018/4/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+(instancetype)sharedInstanced;

/**
 是否开启debug日志,默认开启.
 release默认是关闭的.
 */
@property (nonatomic, assign) BOOL isOpenDebugLog;

- (void)openDB:(NSString *)dbName;
- (void)createTable:(NSString*)tableName sql:(NSString *)createSql;


/**
 @brief 数据库新字段

 @param column 新增字段名
 @param tableName 数据库名
 */
- (void)alertTableColumn:(NSString *)column inTable:(NSString *)tableName;

@end
