//
//  DeleteTimerSwitchApi.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DeleteTimerSwitchApi_h
#define DeleteTimerSwitchApi_h
#import "BaseDriveApi.h"

@interface DeleteTimerSwitchApi : BaseDriveApi

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost Content:(NSNumber *)timerid;

@end

#endif /* DeleteTimerSwitchApi_h */
