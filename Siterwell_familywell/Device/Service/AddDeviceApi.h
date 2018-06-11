//
//  AddDeviceApi.h
//  sHome
//
//  Created by shaop on 2017/1/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface AddDeviceApi : BaseDriveApi
-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey ConnectHost:(NSString *)connecthost;
@end
