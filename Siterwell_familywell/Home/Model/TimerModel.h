//
//  TimerModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef TimerModel_h
#define TimerModel_h
#import "JSONModel+HekrDic.h"
@interface TimerModel:JSONModel
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSNumber<Ignore> *timerid;
@property (nonatomic, assign) NSNumber<Ignore> *enable;
@property (nonatomic,strong) NSNumber<Ignore> * sid;
@property (nonatomic,strong) NSString<Ignore> * week;
@property (nonatomic,strong) NSString<Ignore> * hour;
@property (nonatomic,strong) NSString<Ignore> * min;
@property (nonatomic,strong) NSString<Ignore> *name;
@property(nonatomic,assign) NSString<Ignore> * devTid;
@end

#endif /* TimerModel_h */
