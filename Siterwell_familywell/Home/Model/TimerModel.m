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
        if(self.time.length >= 12){
            [self creatModel];
        }
    }
    return self;
}

- (void)creatModel{
    self.timerid = [self getTimerIdFromTime];
    self.enable = [self getTimerOnFromTime];
    self.sid = [self getTimerSenceGroupFromTime];
    self.hour = [self getHourFromTime];
    self.min = [self getMinFromTime];
    self.week = [self getWeekFromTime];
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

    if(senceGroup ==0){
        return NSLocalizedString(@"在家", nil);
    }else if(senceGroup == 1){
        return NSLocalizedString(@"离家", nil);
    }else if(senceGroup == 2){
        return NSLocalizedString(@"睡眠", nil);
    }else{
        if(model == nil)
        {
            return [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"情景模式", nil),senceGroup ];
        }else{
            return model.systemname;
        }
        
    }

 
}

-(NSString *)getWeekFromTime{
   return [self.time substringWithRange:NSMakeRange(6, 2)];
}

-(NSString *)getHourFromTime{
    int houror =(int)strtoul([[self.time substringWithRange:NSMakeRange(8, 2)] UTF8String],0,16);
    return [NSString stringWithFormat:@"%02d",houror ];
}

-(NSString *)getMinFromTime{
    int min =(int)strtoul([[self.time substringWithRange:NSMakeRange(10, 2)] UTF8String],0,16);
    return [NSString stringWithFormat:@"%02d",min ];
}


@end
