//
//  BaseNetManager.m
//  SiterLink
//
//  Created by CY on 2017/9/4.
//  Copyright © 2017年 CY. All rights reserved.
//

#import "BaseNetManager.h"

@implementation BaseNetManager

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler {
     return [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@, %@", task.currentRequest.URL.absoluteString, error);
        !completionHandler?:completionHandler(nil, error);
    }];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler {
    return [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@, %@", task.currentRequest.URL.absoluteString, error);
        !completionHandler?:completionHandler(nil, error);
    }];
}

+ (id)POSTArray:(NSString *)path parameters:(NSArray *)parameters completionHandler:(void (^)(id, NSError *))completionHandler {
    return [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@, %@", task.currentRequest.URL.absoluteString, error);
        !completionHandler?:completionHandler(nil, error);
    }];
}

+ (id)PUT:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler {
    return [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@, %@", task.currentRequest.URL.absoluteString, error);
        !completionHandler?:completionHandler(nil, error);
    }];
}

+(id)DELETE:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id,NSError *)) completionHandler {
    return  [[[Hekr sharedInstance] sessionWithDefaultAuthorization] DELETE:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !completionHandler?:completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !completionHandler?:completionHandler(nil,error);
    }];
}

+(id)PATCH:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id,NSError *)) completionHandler {
    return [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PATCH:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !completionHandler?:completionHandler(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !completionHandler?:completionHandler(nil,error);
    }];
}

+ (id)AFGET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    return [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler ?: completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !completionHandler ?: completionHandler(nil, error);
    }];
}

+ (id)AFPOST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//响应
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];

    return [manager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler ?: completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !completionHandler ?: completionHandler(nil, error);
    }];
}


@end
