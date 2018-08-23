//
//  PostControllerApi.h
//  sHome
//
//  Created by shaop on 2017/1/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface PostControllerApi : BaseDriveApi
-(id)initWithDrivce:(NSString *)devTid andCtrlKey:(NSString *)ctrlkey DeviceID:(NSNumber *)dev_ID DeviceStatus:(NSString *)device_status ConnectHost:(NSString *)connecthost;
@end
