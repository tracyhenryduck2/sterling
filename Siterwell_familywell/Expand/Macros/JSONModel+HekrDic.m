//
//  JSONModel+HekrDic.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/21.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "JSONModel+HekrDic.h"

@implementation JSONModel (HekrDic)

-(id)initWithHekrDictionary:(NSDictionary *)dic error:(NSError **)error{
    dic = [dic objectForKey:@"params"];
    dic = [dic objectForKey:@"data"];
    if(self = [self initWithDictionary:dic error:error]){
        
    }
    return self;
}

@end
