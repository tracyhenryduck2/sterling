//
//  Single.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/8/16.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "Single.h"
@implementation Single


+(instancetype)sharedInstanced {
    static Single* single;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        single = [[Single alloc] init];
    });
    return single;
}

@end
