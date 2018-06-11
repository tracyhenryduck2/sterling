//
//  UserInfoModel.m
//  sHome
//
//  Created by shaop on 2017/3/7.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"emergencyNumber"}];
}

@end
