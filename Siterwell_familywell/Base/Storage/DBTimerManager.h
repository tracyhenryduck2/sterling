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
- (TimerModel *)queryTimer:(NSNumber *)timerid withDevTid:(NSString *)devTid;
-(NSMutableArray *)queryTimer:(NSString *)hour withMin:(NSString *)min withDevTid:(NSString *)devTid;
- (NSMutableArray *)queryAllTimersTid:(NSString *)devTid;
- (void)deleteTimer:(NSNumber *)timerid withDevTid:(NSString *)devTid;
- (void)updateTimerEnable:(NSNumber *)enable withTimerid:(NSNumber *)timerid withDevTid:(NSString *)DevTid;
- (void)insertTimer:(TimerModel *)timerModel;
@end

#endif /* DBTimerManager_h */
