//
//  SyncTimerSwitchApi.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef SyncTimerSwitchApi_h
#define SyncTimerSwitchApi_h
#import "BaseDriveApi.h"

@interface SyncTimerSwitchApi : BaseDriveApi

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost Content:(NSString *)content;

@end

#endif /* SyncTimerSwitchApi_h */
