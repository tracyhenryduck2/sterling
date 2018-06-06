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
#import "DeviceModel.h"

@interface DBDeviceManager : NSObject
+ (instancetype)sharedInstanced;
- (NSMutableArray *)queryAllDevice:(NSString *)devTid;
- (void)insertDevice:(DeviceModel *)deviceModel;
- (void)insertDevices:(NSArray *)deviceModels;
- (void)deleteDevice:(NSString *)eqid withDevTid:(NSString *)devTid;
@end

#endif /* DBDeviceManager_h */
