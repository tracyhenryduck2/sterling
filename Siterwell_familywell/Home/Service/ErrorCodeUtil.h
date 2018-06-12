//
//  ErrorCodeUtil.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorModel.h"

@interface ErrorCodeUtil : NSObject
+ (NSString *)getErrorMessageWithError:(ErrorModel *)model withDeviceTid:(NSString *)devTid;
+ (NSString *)getMessageWithCode:(long) code;
@end
