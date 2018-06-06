//
//  DBTimerManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBTimerManager_h
#define DBTimerManager_h
#import "DBManager.h"
#import "TimerModel.h"

@interface DBTimerManager:NSObject
+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllTimers:(NSString *)devTid;
- (void)deleteTimer:(NSString *)timerid withDevTid:(NSString *)devTid;
- (void)updateTimerEnable:(NSInteger)enable withTimerid:(NSString *)timerid withDevTid:(NSString *)DevTid;
@end

#endif /* DBTimerManager_h */
