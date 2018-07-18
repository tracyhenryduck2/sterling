//
//  DBGatewayManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBGatewayManager_h
#define DBGatewayManager_h
#import "DBManager.h"
#import "GatewayModel+Siterwell.h"

@interface DBGatewayManager:NSObject
+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllGateway;
- (void)deleteGateway:(NSString *)devTid;
- (void)updateGatewayName:(NSString *)name withDevTid:(NSString *)DevTid;
-(GatewayModel *)queryForChosedGateway;
- (void)deleteGatewayTable;
@end

#endif /* DBGatewayManager_h */
