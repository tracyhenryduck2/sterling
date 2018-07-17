//
//  DBSceneManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBSceneManager_h
#define DBSceneManager_h
#import "DBManager.h"
#import "SceneModel.h"

@interface DBSceneManager:NSObject
+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllScenewithDevTid:(NSString *)devTid;
@end
#endif /* DBSceneManager_h */
