//
//  BaseDriveApi.m
//  sHome
//
//  Created by shaop on 2016/12/13.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"
#import <HekrApi.h>

@implementation BaseDriveApi

- (id)requestArgumentCommand {
    return nil;
}


- (id)requestArgumentConnectHost{
    return nil;
}

-(void)startWithObject:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success {

        NSLog(@"发送的数据为%@",[self requestArgumentCommand]);
//        [[Hekr sharedInstance] send:[self requestArgumentCommand] to:[self requestArgumentDevice] callback:^(id respond,NSError* error){
//            if (error) {
//                if (error.code != -1) {
//                    failure(respond , error);
//                }
//            } else {
//                success(respond, error);
//            }
////            if (respond) {
////                success(respond, error);
////            }
//        }];
        //发送websocket指令要指定connectHost
//        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];

        [[Hekr sharedInstance] sendNet:[self requestArgumentCommand] toHost:[self requestArgumentConnectHost] timeout:20.0f callback:^(id data, NSError *err) {
//            typeof(self) sself = wself;
            success(data, err);
        }];
        

    
}

- (void)startUdpObj:(id)obj CompletionBlockWithSuccess:(void (^)(id, NSError *))success failure:(void (^)(id, NSError *))failure {
//    [[MyUdp shared] recv:[self requestArgumentFilter] obj:obj callback:^(id obj, id data, NSError *error) {
//        if (data) {
//            NSLog(@"%@",data);
//            success(data , error);
//        }
//    }];
//
//    [[MyUdp shared] senData:[self requestArgumentCommand]];
}

-(void)dealloc{
    NSLog(@">>>>api dealloc");
}

@end
