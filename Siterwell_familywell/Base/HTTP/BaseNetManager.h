//
//  BaseNetManager.h
//  SiterLink
//
//  Created by CY on 2017/9/4.
//  Copyright © 2017年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HekrAPI.h>

@interface BaseNetManager : NSObject

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObj, NSError *error))completionHandler;

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObj, NSError *error))completionHandler;

+ (id)POSTArray:(NSString *)path parameters:(NSArray *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;

+ (id)PUT:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;

+(id)DELETE:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id,NSError *)) completionHandler;

+(id)PATCH:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id,NSError *)) completionHandler;

+ (id)AFGET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObj, NSError *error))completionHandler;

+ (id)AFPOST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObi, NSError *error))completionHandler;

@end
