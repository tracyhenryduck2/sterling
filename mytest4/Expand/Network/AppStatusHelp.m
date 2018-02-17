//
//  AppStatusHelp.m
//  sHome
//
//  Created by shap on 2017/3/30.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AppStatusHelp.h"
#import "ESP_NetUtil.h"

@implementation AppStatusHelp

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+ (NSString *)getWifiIP{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
  
        NSString *ip = [ESP_NetUtil getLocalIPv4];
        NSArray *ipArray = [ip componentsSeparatedByString:@"."];
        
        if (ipArray.count == 4) {
            ip = [NSString stringWithFormat:@"%@.%@.%@.255",ipArray[0],ipArray[1],ipArray[2]];
            return ip;
        }
    return nil;
}


@end
