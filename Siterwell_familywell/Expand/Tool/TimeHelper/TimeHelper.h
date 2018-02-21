//
//  TimeHelper.h
//  HuanBao
//
//  Created by shaop on 16/8/23.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHelper : NSObject

+(NSString *)TimestampToData:(NSString *)timestamp;

+(NSString *)TimestampToDay:(NSString *)timestamp;

+(NSString *)TimestampToMinute:(NSString *)timestamp;

+(NSString *)DataToTimestamp:(NSString *)data;

+(NSString *)getSTHTime;

@end
