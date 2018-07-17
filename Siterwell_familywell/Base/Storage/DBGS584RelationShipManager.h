//
//  DBGS584RelationShipManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBGS584RelationShipManager_h
#define DBGS584RelationShipManager_h
#import "DBManager.h"
#import "GS584RelationShip.h"

@interface DBGS584RelationShipManager:NSObject
+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllGS584RelationShipwithDevTid:(NSString *)devTid withSid:(NSString *)sid;
@end

#endif /* DBGS584RelationShipManager_h */
