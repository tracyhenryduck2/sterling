//
//  BaseDriveApi.m
//  sHome
//
//  Created by shaop on 2016/12/13.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"
#import "DeviceModel.h"

@implementation BaseDriveApi

- (id)requestArgumentCommand {
    return nil;
}


- (NSString *)requestArgumentHost{
    return nil;
}

-(void)startWithObject:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success failure:(void(^)(id data,NSError* error))failure{

        [[Hekr sharedInstance] sendNet:[self requestArgumentCommand] toHost:[self requestArgumentHost] timeout:20.0f callback:^(id data, NSError *err) {
//            typeof(self) sself = wself;
            DDLogVerbose(@" recv response:%@",data);
            if(data){
                success(data, err);
            }else{
                if (err.code != -1) {
                    failure(data, err);
                }
            }
        }];
        

    
}

- (void)startUdpObj:(id)obj CompletionBlockWithSuccess:(void (^)(id, NSError *))success failure:(void (^)(id, NSError *))failure {

}

-(void)dealloc{
    NSLog(@">>>>api dealloc");
}

@end
