//
//  WarningModel.h
//  sHome
//
//  Created by CY on 2017/11/25.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BatterHelp.h"

@interface WarningModel : NSObject

@property (nonatomic) NSString *content;

@property (nonatomic) NSNumber *reportTime;

@property (nonatomic) NSString *subject;

@property (nonatomic) NSString *answer_content;

+(NSString *)getAlertWithDevType:(NSString *)type status:(NSString *) statusa;

@end
