//
//  NameHelper.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/31.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef NameHelper_h
#define NameHelper_h
#import "BatterHelp.h"
@interface NameHelper:NSObject

+ (NSString *) convertDataToHexStr:(NSData *)data;
+ (NSString *) getASCIIFromName:(NSString *)name;
+ (NSString *) getNameFromASCII:(NSString *)Ascii;

@end

#endif /* NameHelper_h */
