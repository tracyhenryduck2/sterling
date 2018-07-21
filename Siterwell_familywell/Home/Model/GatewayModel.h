//
//  GatewayModel.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/5.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef GatewayModel_h
#define GatewayModel_h
@interface GatewayModel:JSONModel

@property(nonatomic , strong) NSString *deviceName;

@property(nonatomic , strong) NSString *devTid;

@property(nonatomic , strong) NSString *ssid;

@property(nonatomic , strong) NSString *ctrlKey;

@property(nonatomic , strong) NSString *productPublicKey;

@property(nonatomic , strong) NSString *bindKey;

@property(nonatomic , strong) NSString *binVersion;

@property(nonatomic , strong) NSString *binType;

@property(nonatomic , strong) NSString *online;

@property (nonatomic) NSString<Optional> *connectHost;
@end
#endif /* GatewayModel_h */
