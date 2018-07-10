//
//  CYNetManager.h
//  sHome
//
//  Created by CY on 2017/11/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseNetManager.h"
#import "NewWeatherModel.h"

@interface CYNetManager : BaseNetManager
+ (id)getWeatherWithParams:(NSDictionary *)params handler:(void (^)(NewWeatherModel *model, NSError *error))handler;

+ (id)getLocationWithParams:(NSDictionary *)params handler:(void (^)(NSString *address, NSString *errorStr))handler;

@end
