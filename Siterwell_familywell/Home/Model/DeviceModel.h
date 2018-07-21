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

@property(strong,nonatomic) NSString * devicename;
@property(nonatomic)        NSInteger    eqid;
@property(nonatomic,assign) NSString * devicetype;
@property(nonatomic,assign) NSString * devicestatus;
@property(nonatomic,assign) NSString * devTid;
@end

#endif /* DeviceModel_h */
