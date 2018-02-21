//
//  NSString+ArryValue.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14-6-13.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ArryValue)
/**
 *  @brief  JSON字符串转成NSArray
 *
 *  @return NSArray
 */
-(NSArray *) arrayValue;
@end
