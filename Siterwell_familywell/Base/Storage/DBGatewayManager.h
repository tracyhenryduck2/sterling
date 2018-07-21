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
#import "GatewayModel.h"

@interface DBGatewayManager:NSObject
+ (instancetype)sharedInstanced;
- (void)insertDevices:(NSArray *)gatewayModels;
- (NSMutableArray *)queryAllGateway;
- (void)deleteGateway:(NSString *)devTid;
- (void)updateGatewayName:(NSString *)name withDevTid:(NSString *)DevTid;
-(GatewayModel *)queryForChosedGateway:(NSString *)devTid;
- (void)deleteGatewayTable;
@end

#endif /* DBGatewayManager_h */
