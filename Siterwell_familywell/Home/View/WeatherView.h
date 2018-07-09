//
//  WeatherView.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/9.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef WeatherView_h
#define WeatherView_h
#import "NewWeatherModel.h"

@interface WeatherView : UIView

@property (nonatomic) NewWeatherModel *model;

@property (nonatomic) NSString *address;

- (instancetype)initWithFrame:(CGRect)frame;

@end

#endif /* WeatherView_h */
