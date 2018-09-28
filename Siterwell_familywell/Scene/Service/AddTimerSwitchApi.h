//
//  AddTimerSwitchApi.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef AddTimerSwitchApi_h
#define AddTimerSwitchApi_h
#import "BaseDriveApi.h"

@interface AddTimerSwitchApi : BaseDriveApi

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)conncetHost Content:(NSString *)content;

@end

#endif /* AddTimerSwitchApi_h */
