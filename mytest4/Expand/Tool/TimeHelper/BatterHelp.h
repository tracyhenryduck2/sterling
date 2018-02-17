//
//  BatterHelp.h
//  sHome
//
//  Created by shaop on 2017/1/19.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BatterHelp : NSObject

+ (NSString *)getBatterFormDevice:(NSString *)batter;

+ (NSString *)getCRCCode:(unsigned char [])code lenght:(int)length;

+ (NSString *)getDeviceCRCCode:(NSString *)msg;

+ (NSString *)getTimerSceneCRCCode:(NSString *)msg;

+ (NSData *)hexStringToData:(NSString *)hexString ;

/**
 十进制转十六进制
 
 @param tmpid 十进制
 @return 十六进制
 */
+ (NSString *)gethexBybinary:(long long int)tmpid;

/**
 十六进制转十进制
 @param aHexString 十六进制
 @return 十进制
 */
+ (NSNumber *) numberHexString:(NSString *)aHexString;

/**
 十六进制转二进制
 
 @param hex 十六进制
 @return 二进制
 */
+(NSString *)getBinaryByhex:(NSString *)hex;

/**
 二进制转十进制
 
 @param binary 二进制
 @return 十进制
 */
+ (NSString *)getDecimalBybinary:(NSString *)binary;

@end
