//
//  TimeModel.h
//  sHome
//
//  Created by shaop on 2017/1/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeModel : JSONModel


@property (nonatomic,strong) NSString *time;

@property (nonatomic, strong) NSNumber<Ignore> *timer_id;

@property (nonatomic, strong) NSString<Ignore> *timer_on;//是否使用

@property (nonatomic , strong) NSString<Ignore> *week;

@property (nonatomic , strong) NSString<Ignore> *Hour;

@property (nonatomic , strong) NSString<Ignore> *Minute;

@property (nonatomic , strong) NSString<Ignore> *Second;

@property (nonatomic, strong) NSString<Ignore> *sence_group;

@property (nonatomic, strong) NSString<Ignore> *sence_name;

@end
