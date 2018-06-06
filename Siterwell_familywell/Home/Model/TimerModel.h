//
//  TimerModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef TimerModel_h
#define TimerModel_h
@interface TimerModel:JSONModel

@property (nonatomic, strong) NSString *timerid;
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic,strong) NSString * sid;
@property (nonatomic,strong) NSString * week;
@property (nonatomic,strong) NSString * hour;
@property (nonatomic,strong) NSString * min;
@property (nonatomic,strong) NSString * devTid;
@end

#endif /* TimerModel_h */
