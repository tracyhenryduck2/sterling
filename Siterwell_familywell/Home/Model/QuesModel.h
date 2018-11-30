//
//  QuesModel.h
//  SiterLink
//
//  Created by CY on 2017/6/12.
//  Copyright © 2017年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuesModel : NSObject

//@property (nonatomic) NSArray *qaArray;

@property (nonatomic) NSString *question;

@property (nonatomic) NSString *answer;

@property (nonatomic, assign) BOOL expand;

+(instancetype)qaWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
