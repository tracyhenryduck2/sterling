//
//  AddDeviceApi.h
//  sHome
//
//  Created by shaop on 2017/1/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface AddDeviceApi : BaseDriveApi
-(id)initWithDrivce:(NSString *)devTid andCtrlKey:(NSString *)ctrlkey DeviceStatus:(NSArray *)device_status ConnectHost:(NSString *)connecthost;
@end
