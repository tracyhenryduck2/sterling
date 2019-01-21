//
//  replaceDeviceApi.h
//  sHome
//
//  Created by shaop on 2016/12/29.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface replaceDeviceApi : BaseDriveApi
-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey mDeviceID:(NSNumber *)mDeviceId ConnectHost:(NSString *)connecthost;
@end
