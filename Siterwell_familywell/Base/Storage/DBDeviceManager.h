//
//  DBDeviceManager.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/1.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DBDeviceManager_h
#define DBDeviceManager_h
#import "DBManager.h"
#import "ItemData.h"

@interface DBDeviceManager : NSObject
+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllDevice:(NSString *)devTid;
- (ItemData *)queryDeviceModel:(NSNumber *)device_ID withDevTid:(NSString *)devTid;
- (void)insertDevice:(ItemData *)deviceModel;
- (void)insertDevices:(NSArray *)deviceModels;
- (void)deleteDevice:(NSNumber *)eqid withDevTid:(NSString *)devTid;
@end

#endif /* DBDeviceManager_h */
