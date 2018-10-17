//
//  GatewayVersionModel.h
//  sHome
//
//  Created by shap on 2017/4/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class DevFirmwareOTARawRuleVO;

@interface GatewayVersionModel : JSONModel

@property (nonatomic, strong) NSString *devTid;

@property (nonatomic, assign) BOOL update;

@property (nonatomic, strong) DevFirmwareOTARawRuleVO<Optional> *devFirmwareOTARawRuleVO;

@end

@interface DevFirmwareOTARawRuleVO : JSONModel

@property (nonatomic, strong) NSString *binUrl;

@property (nonatomic, strong) NSString *md5;

@property (nonatomic, strong) NSString *latestBinType;

@property (nonatomic, strong) NSString *latestBinVer;

@property (nonatomic, strong) NSNumber *size;

@end
