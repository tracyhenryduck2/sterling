//
//  WarnModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/11.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef WarnModel_h
#define WarnModel_h
@interface WarnModel:JSONModel

@property (nonatomic, assign) NSInteger warnid;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, assign) NSInteger eqid;

@property (nonatomic, strong) NSString *deviceName;

@property (nonatomic, strong) NSString *deviceStatus;

@property (nonatomic, strong) NSDate *time;

@property (nonatomic, strong) NSString *mid;

@property (nonatomic, strong) NSString *devTid;
@end

#endif /* WarnModel_h */
