//
//  SiterTools.m
//  mytest4
//
//  Created by iMac on 2018/2/20.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "SiterTools.h"
static id _instance;
@interface SiterTools()

@end

@implementation SiterTools

+(id)allocWithZone:(struct _NSZone*)zone{
    @synchronized(self){
        if(_instance){
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}



+ (instancetype)sharedInstanceTool{
    @synchronized(self){
        if(_instance){
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

@end
