//
//  TimeHelper.m
//  HuanBao
//
//  Created by shaop on 16/8/23.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "TimeHelper.h"
#import "BatterHelp.h"

@implementation TimeHelper

+(NSString *)TimestampToData:(NSString *)timestamp{
    
    NSTimeInterval timeInterval = [timestamp doubleValue];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *strDate = [formatter stringFromDate:confromTimesp];
    
    return strDate;
}

+(NSString *)TimestampToDay:(NSString *)timestamp{
    NSTimeInterval timeInterval = [timestamp doubleValue];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *strDate = [formatter stringFromDate:confromTimesp];
    
    return strDate;
}

+(NSString *)TimestampToMinute:(NSString *)timestamp{
    NSTimeInterval timeInterval = [timestamp doubleValue];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *strDate = [formatter stringFromDate:confromTimesp];
    
    return strDate;
}

+(NSString *)DataToTimestamp:(NSString *)strdata{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:strdata];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}

+(NSString *)getSTHTime{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int weekday = (int) [dateComponent weekday];
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
    
    NSString *wd = @"";
    if(weekday == 1){
        weekday = 7;
    }else{
        weekday -= 1;
    }
    wd = [NSString stringWithFormat:@"0%d",weekday];

    NSString *hour1 = @"";
    NSString *hour2 = [BatterHelp gethexBybinary:hour];
    if(hour2.length < 2){
        hour1 = [NSString stringWithFormat:@"0%@",hour2];
    }else{
        hour1 = hour2;
    }
    
    NSString *min1 = @"";
    NSString *min2 = [BatterHelp gethexBybinary:minute];
    if(min2.length < 2){
        min1 = [NSString stringWithFormat:@"0%@",min2];
    }else{
        min1 = min2;
    }
    
    NSString *sec1 = @"";
    NSString *sec2 = [BatterHelp gethexBybinary:second];
    if(sec2.length<2){
        sec1 =[NSString stringWithFormat:@"0%@",sec2];
    }else{
        sec1 =sec2;
    }
    
    NSString *timeCode =  [NSString stringWithFormat:@"%@%@%@%@",wd,hour1,min1,sec1];
    
    return timeCode;
}
@end
