//
//  CancelAddingApi.h
//  sHome
//
//  Created by shaop on 2017/4/20.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface CancelAddingApi : BaseDriveApi
-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey ConnectHost:(NSString *)connecthost;
@end
