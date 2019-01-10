//
//  ClickApi.h
//  Siterwell_familywell
//
//  Created by Henry on 2019/1/10.
//  Copyright © 2019 iMac. All rights reserved.
//

#ifndef ClickApi_h
#define ClickApi_h
#import "BaseDriveApi.h"

@interface ClickApi : BaseDriveApi
-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Domain:(NSString *)domain Scene:(NSNumber *)scene_id;
@end

#endif /* ClickApi_h */
