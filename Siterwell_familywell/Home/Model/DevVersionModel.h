//
//  DevVersionModel.h
//  SiterLink
//
//  Created by CY on 2017/9/27.
//  Copyright © 2017年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DevFirmwareOTARawRuleVO;

@interface DevVersionModel : NSObject

@property (nonatomic, copy) NSString *devTid;

@property (nonatomic, assign) BOOL update;

@property (nonatomic) DevFirmwareOTARawRuleVO *devFirmwareOTARawRuleVO;

@end

@interface DevFirmwareOTARawRuleVO : NSObject

@property (nonatomic, copy) NSString *binUrl;

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, copy) NSString *latestBinType;

@property (nonatomic, copy) NSString *latestBinVer;

@property (nonatomic, copy) NSNumber *size;

//@property (nonatomic, assign) NSInteger size;

@end
