//
//  DeviceModel.h
//  Siterwell_familywell
//
//  Created by iMac on 2018/4/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef DeviceModel_h
#define DeviceModel_h
#import "JSONModel+HekrDic.h"
@interface DeviceModel:JSONModel


@property(nonatomic)        NSNumber * device_ID;
@property(nonatomic,assign) NSString * device_name;
@property(nonatomic,assign) NSString * device_status;
@property(strong,nonatomic) NSString<Ignore> * device_custom_name;
@property(nonatomic,assign) NSString<Ignore> * devTid;
@end

#endif /* DeviceModel_h */
