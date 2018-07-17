//
//  DBSceneReManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/17.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBSceneReManager_h
#define DBSceneReManager_h
#import "DBManager.h"
#import "SceneRelationShip.h"

@interface DBSceneReManager:NSObject
+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllGS584RelationShipwithDevTid:(NSString *)devTid;
@end

#endif /* DBSceneReManager_h */
