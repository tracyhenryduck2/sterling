//
//  NSString+ArryValue.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14-6-13.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import "NSString+DictionaryValue.h"

@implementation NSString (ArryValue)
/**
 *  @brief  JSON字符串转成NSArray
 *
 *  @return NSArray
 */
-(NSArray *) arrayValue{
    NSError *errorJson;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonArray;
}

@end
