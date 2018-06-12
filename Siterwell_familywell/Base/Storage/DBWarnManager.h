//
//  DBWarnManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/11.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBWarnManager_h
#define DBWarnManager_h

#import "DBManager.h"
#import "WarnModel.h"

@interface DBWarnManager:NSObject
+ (instancetype)sharedInstanced;
- (void)insertWarnInfo:(WarnModel *) warnModel;
- (void)insertWarnInfos:(NSArray *)warnModels;
- (NSMutableArray *)queryAllWarnInfo:(NSString *)devTid;
@end

#endif /* DBWarnManager_h */
