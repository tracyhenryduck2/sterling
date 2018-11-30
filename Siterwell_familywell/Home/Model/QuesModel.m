//
//  QuesModel.m
//  SiterLink
//
//  Created by CY on 2017/6/12.
//  Copyright © 2017年 CY. All rights reserved.
//

#import "QuesModel.h"

@implementation QuesModel

//类方法和对象方法的命名格式固定，其中类方法的实现格式也是固定的
+ (instancetype)qaWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
//先将父类实例化，才能实例化子类
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict]; //KVC赋值
    }
    return self;
}


@end
