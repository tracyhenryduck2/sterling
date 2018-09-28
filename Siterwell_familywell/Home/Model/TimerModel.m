//
//  TimerModel.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "TimerModel.h"
#import "DBSystemSceneManager.h"

@implementation TimerModel

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    
    if (self = [super initWithDictionary:dict error:err]) {
        
    }
    return self;
}

- (void)creatModel{
    self.timerid = [self getTimerIdFromTime];
    self.enable = [self getTimerOnFromTime];
    self.sid = [self getTimerSenceGroupFromTime];
    
}

- (NSNumber *)getTimerIdFromTime{
    int timerId =(int)strtoul([[self.time substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
    
    return [NSNumber numberWithInt:timerId];
}

- (NSNumber *)getTimerOnFromTime{
    NSString *timerOn = [self.time substringWithRange:NSMakeRange(2, 2)];
    if([timerOn isEqualToString:@"00"]){
        return @0;
    }else{
         return @1;
    }
  
}

- (NSNumber *)getTimerSenceGroupFromTime{
    int senceGroup = (int)strtoul([[self.time substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
    return [NSNumber numberWithInt:senceGroup];;
}

- (NSString *)getTimerSenceNameBySenceGroup:(NSString *)devTid{
    int senceGroup = (int)strtoul([[self.time substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
   SystemSceneModel *model = [[DBSystemSceneManager sharedInstanced] querySystemScene:[NSNumber numberWithInt:senceGroup] withDevTid:devTid];

    return model.systemname;
}

//- (TimeModel *)getTimerWHMSFromTime{
//
//    TimeModel *timeMd = [[TimeModel alloc] init];
//    NSString *timeW = [self.time substringWithRange:NSMakeRange(6, 2)];
//    timeW = [BatterHelp getBinaryByhex:timeW];
//
//    NSString *timeH = [self.time substringWithRange:NSMakeRange(8, 2)];
//    NSString *timeM = [self.time substringWithRange:NSMakeRange(10, 2)];
//
//    timeMd.week = timeW;
//    timeMd.Hour = [[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeH]] length] < 2?[NSString stringWithFormat:@"0%@",[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeH]] ]:[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeH]];
//    timeMd.Minute = [[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeM]] length] < 2?[NSString stringWithFormat:@"0%@",[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeM]] ]:[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeM]];;
//
//    return timeMd;
//}

@end
