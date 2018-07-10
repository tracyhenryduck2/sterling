//
//  CYNetManager.m
//  sHome
//
//  Created by CY on 2017/11/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "CYNetManager.h"

#define kWeatherPath  @"http://api.openweathermap.org/data/2.5/weather"
#define kLocationPath  @"http://maps.google.cn/maps/api/geocode/json"

@implementation CYNetManager

+ (id)getWeatherWithParams:(NSDictionary *)params handler:(void (^)(NewWeatherModel *, NSError *))handler {
    return [self GET:kWeatherPath parameters:params completionHandler:^(id responseObj, NSError *error) {
        NewWeatherModel *model = [[NewWeatherModel alloc] init];
        model.humidity = responseObj[@"main"][@"humidity"];
        model.temp = responseObj[@"main"][@"temp"];
        model.weather = responseObj[@"weather"][0][@"description"];
        model.icon = responseObj[@"weather"][0][@"icon"];
        !handler ?: handler(model, error);
    }];
}

+ (id)getLocationWithParams:(NSDictionary *)params handler:(void (^)(NSString *, NSString *))handler {
    return [self GET:kLocationPath parameters:params completionHandler:^(id responseObj, NSError *error) {
        NSString *errStr = responseObj[@"status"];
        NSArray *results = responseObj[@"results"];
        NSArray *addresses = results.firstObject[@"address_components"];
        NSString *address = addresses[1][@"long_name"];
        !handler ?: handler(address, errStr);
    }];
}

@end
